#include "../include/gpu_prog.h"

int HIP_CHECK_A(hipError_t status)           
{                                   
    const hipError_t err = status; 
    if (err != hipSuccess)
    {
        std::cerr << "HIP error " << status << " " <<hipGetErrorName(status) << " at " << __LINE__ << std::endl;
        return (ERR);
    }
    return (OK);
};   

int clean_host_memory(float *arr_a, float *arr_b, float *arr_result)
{
    free(arr_a);
    free(arr_b);
    free(arr_result);
    return (OK);
}

int clean_device_memory(float *d_arr_a, float *d_arr_b, float *d_arr_result)
{
    if(HIP_CHECK_A(hipFree(d_arr_a)) == ERR)
        std::cout << "hipFree d_arr_a error" << std::endl;
    if(HIP_CHECK_A(hipFree(d_arr_b)) == ERR)
        std::cout << "hipFree d_arr_b error" << std::endl;
    if(HIP_CHECK_A(hipFree(d_arr_result)) == ERR)
        std::cout << "hipFree d_arr_result error" << std::endl;
    
    return (OK);
}