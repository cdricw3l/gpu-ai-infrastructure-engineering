#include "../include/gpu_prog.h"

__global__ void gpu_calculation(float *d_arr_a, float *d_arr_b, float *d_arr_result)
{
   
    int global_idx;


    global_idx = threadIdx.x + blockIdx.x * blockDim.x;

    d_arr_result[global_idx] = d_arr_a[global_idx] * d_arr_b[global_idx];

    
}

int init_device_memory(float **d_arr_a, float **d_arr_b, float **d_arr_result)
{

    if(HIP_CHECK_A(hipMalloc(d_arr_a, sizeof(float) * N)) == ERR)
        goto err_a;
    if(HIP_CHECK_A(hipMalloc(d_arr_b, sizeof(float) * N)) == ERR)
        goto err_b;
    if(HIP_CHECK_A(hipMalloc(d_arr_result,sizeof(float) * N)) == ERR)
        goto err_c;

    std::cout << "Initialisation device memory: SUCCES" << std::endl;
    return (OK);

    err_a:
        return (ERR);
    err_b:
        HIP_CHECK_A(hipFree(d_arr_a));
        return (ERR);
    err_c:
        HIP_CHECK_A(hipFree(d_arr_a));
        HIP_CHECK_A(hipFree(d_arr_b));
        return (ERR);

}

int gpu_bench(float *arr_a, float *arr_b, float *arr_result)
{
    printf("We are in gpu mode\n");
    int r;
    float *d_arr_a = NULL;
    float *d_arr_b = NULL;
    float *d_arr_result = NULL;
    struct timespec start;
    struct timespec end;

    assert(arr_a);
    assert(arr_b);
    assert(arr_result);

    if(init_device_memory(&d_arr_a, &d_arr_b, &d_arr_result) == ERR)
    {
        std::cout << "Error initialisation device memory" << std::endl;
        return(ERR);
    }

    HIP_CHECK_A(hipMemcpy(d_arr_a, arr_a, sizeof(float) * N, hipMemcpyHostToDevice));
    HIP_CHECK_A(hipMemcpy(d_arr_b, arr_b, sizeof(float) * N, hipMemcpyHostToDevice));
    
    assert(d_arr_a);
    assert(d_arr_b);
    assert(d_arr_result);
    r = OK;
    
    int block_size = 256;
    int grid_size = (N + block_size - 1) / block_size;
    clock_gettime(CLOCK_MONOTONIC, &start);
    gpu_calculation<<<grid_size, block_size>>>(d_arr_a,d_arr_b,d_arr_result);
    HIP_CHECK_A(hipDeviceSynchronize());
    clock_gettime(CLOCK_MONOTONIC, &end);
    std::cout << "gpu_calculation" << " elapsed time(ms) : " << (((end.tv_sec - start.tv_sec) * BILLION) + (end.tv_nsec - start.tv_nsec)) / MILLION << " ms" << std::endl;

    HIP_CHECK_A(hipMemcpy(arr_result, d_arr_result, sizeof(float) * N, hipMemcpyDeviceToHost));
    if(MODE_DISPLAY)
        display_arr(arr_a, arr_b, arr_result);

    clean_host_memory(arr_a, arr_b, arr_result);
    clean_device_memory(d_arr_a, d_arr_b, d_arr_result);
    return (r);
}