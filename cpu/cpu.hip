#include "../include/gpu_prog.h"

int vector_mul(float *arr_a, float *arr_b, float *arr_result)
{
    long i;

    if (!arr_a || !arr_b || !arr_result)
        return (ERR);
    
    for (i = 0; i < N; i++)
    {
        arr_result[i] = arr_a[i] * arr_b[i];
    }
    return (OK);
}

int cpu_bench(float *arr_a, float *arr_b, float *arr_result)
{
    int r;
    long i;
    
    assert(arr_a);
    assert(arr_b);
    assert(arr_result);
    
    r = OK;
    for (i = 0; i < N; i++)
    {
        arr_a[i] = (float)rand() / (float)RAND_MAX;
        arr_b[i] = (float)rand() / (float)RAND_MAX;
    }
    printf("We are in cpu mode\n");
    time_mesurement_cpu(vector_mul, arr_a, arr_b, arr_result, "vector_mul");
    if (OUT_MODE_RESULT)
        display_result(arr_a, arr_b, arr_result);
    clean_host_memory(arr_a, arr_b, arr_result);
    return (r);
}
