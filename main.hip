#include "include/gpu_prog.h"


static int get_mode(int argc, char **argv)
{
    if (argc == 1 || (argc == 2 && !strcmp(argv[1],"cpu")))
        return (MODE_CPU);
    else if (argc == 2 && !strcmp(argv[1],"gpu" ))
        return (MODE_GPU);
    std::cout << "Wrong argument" << std::endl;
    return (ERR);
}



int main(int argc, char **argv)
{
    float *arr_a = NULL;
    float *arr_b = NULL;
    float *arr_result = NULL;
    int mode;

    mode = get_mode(argc, argv);
    if (mode == ERR)
        return (ERR);
    if (init_host_memory_thread(&arr_a, &arr_b, &arr_result) == ERR)
    {
        std::cout << "Error initialisation host memory" << std::endl;
        return (ERR);
    }
    switch (mode)
    {
        case MODE_CPU:
            cpu_bench(arr_a, arr_b, arr_result);
            break;
        case MODE_GPU:
            gpu_bench(arr_a, arr_b, arr_result);
            break;
    }
    return (0);
}

