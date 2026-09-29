#ifndef GPU_PROG_H
#define GPU_PROG_H

#include <cstdio>
#include <iostream>
#include <string.h>
#include <assert.h>
#include <iomanip> 
#include <hip/hip_runtime.h>
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <threads.h>

#define BILLION  1000000000L
#define MILLION  1000000L
#define N 24000000
#define HIP_CHECK(x) (assert((x) == hipSuccess))

#define OK  0
#define ERR 1
#define MODE_CPU 2
#define MODE_GPU 3
#define MODE_DISPLAY 0
#define OUT_MODE_RESULT 0

#define NB_THREAD 24

typedef struct s_memory_thread
{
    int thread;
    float *arr_a;
    float *arr_b;

} t_memory_thread;


int gpu_bench(float *arr_a, float *arr_b, float *arr_result);
int cpu_bench(float *arr_a, float *arr_b, float *arr_result);
void display_arr(float *arr_a, float *arr_b, float *arr_result);
__host__ void time_mesurement_cpu(int (*f)(float *, float *, float *), float *arr_a,float *arr_b,float *arr_r, std::string name);


/* memory */

int init_host_memory(float **arr_a, float **arr_b, float **arr_result);
int init_host_memory_thread(float **arr_a, float **arr_b, float **arr_result);

/* tools */

int display_result(float *arr_a, float *arr_b, float *arr_result);
int clean_host_memory(float *arr_a, float *arr_b, float *arr_result);
int clean_device_memory(float *d_arr_a, float *d_arr_b, float *d_arr_result);
int HIP_CHECK_A(hipError_t status);

#endif