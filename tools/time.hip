#include "../include/gpu_prog.h"

__host__ void time_mesurement_cpu(int (*f)(float *, float *, float *), float *arr_a,float *arr_b,float *arr_r, std::string name)
{
    
    struct timespec start;
    struct timespec end;

    clock_gettime(CLOCK_MONOTONIC, &start);
    f(arr_a,arr_b,arr_r);
    clock_gettime(CLOCK_MONOTONIC, &end);
    std::cout << name << " elapsed time(ms) : " << (((end.tv_sec - start.tv_sec) * BILLION) + (end.tv_nsec - start.tv_nsec)) / MILLION << " ms" << std::endl;
}

 