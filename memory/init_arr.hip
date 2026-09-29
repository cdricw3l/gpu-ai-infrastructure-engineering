#include "../include/gpu_prog.h"

int init_host_memory(float **arr_a, float **arr_b, float **arr_result)
{
    long i;

    *arr_a = (float *)malloc(sizeof(float) * N);
    if (!*arr_a)
    {
        perror("Malloc error arr_a");
        return (ERR);
    }
    *arr_b = (float *)malloc(sizeof(float) * N);
    if (!*arr_b)
    {
        perror("Malloc error arr_b");
        free(*arr_a);
        return (ERR);
    }
    *arr_result = (float *)malloc(sizeof(float) * N);
    if (!*arr_result)
    {
        perror("Malloc error arr_result");
        free(*arr_a);
        free(*arr_b);
        return (ERR);
    }
    for (i = 0; i < N; i++)
    {
        (*arr_a)[i] = (float)rand() / (float)RAND_MAX;
        (*arr_b)[i] = (float)rand() / (float)RAND_MAX;
    }
    std::cout << "Initialisation host memory: SUCCES" << std::endl;
    return (OK);
}