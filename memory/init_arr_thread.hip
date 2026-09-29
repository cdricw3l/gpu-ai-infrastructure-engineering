#include "../include/gpu_prog.h"


void *thread_routine(void *data)
{
    t_memory_thread *memory;

    memory = (t_memory_thread *)data;
    for (size_t i = 0; i < (N / NB_THREAD); i++)
    {
        memory->arr_a[i] = (float)rand() / (float)RAND_MAX;
        memory->arr_b[i] = (float)rand() / (float)RAND_MAX;
        memory->thread++;
    }
    return (NULL);
}


int launch_thread(t_memory_thread memory[NB_THREAD])
{
    pthread_t thread[NB_THREAD];
    size_t i;
    for (i = 0; i < NB_THREAD; i++)
    {
        if(pthread_create(&thread[i], NULL,thread_routine,  &memory[i]))
            break;
    }
    for (i = 0; i < NB_THREAD; i++)
        pthread_join(thread[i], NULL);
    return (OK);
}

int init_memory_data(t_memory_thread memory[NB_THREAD], float *arr_a, float *arr_b)
{

    int i;
    int j;
    
    j = 0;
    for (i = 0; i < NB_THREAD; i++)
    {
        memory[i].thread = j;
        memory[i].arr_a = &arr_a[j];
        memory[i].arr_b = &arr_b[j];
        j+= (N / NB_THREAD);
    }
    return (OK);
}

int init_host_memory_thread(float **arr_a, float **arr_b, float **arr_result)
{
    t_memory_thread memory[NB_THREAD];

    memset(memory, 0, sizeof(t_memory_thread) * NB_THREAD);
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
    init_memory_data(memory, *arr_a, *arr_b);
    
    assert(launch_thread(memory) == OK);
    std::cout << "Initialisation host memory: SUCCES" << std::endl;
    return (OK);
}