#include "../include/gpu_prog.h"

void *thread_data(void *data)
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
    int return_code;
    size_t i;
    pthread_t thread[NB_THREAD];

    return_code = OK;
    for (i = 0; i < NB_THREAD; i++)
    {
        if(pthread_create(&thread[i], NULL,thread_data,  &memory[i]))
        {
            return_code = ERR;
            break;
        }
    }
    for (i = 0; i < NB_THREAD; i++)
    {
        if(pthread_join(thread[i], NULL))
            return_code = ERR;
    }
    return (return_code);
}

static int thread_data_initialisation(float *arr_a, float *arr_b)
{

    int i;
    int j;
    t_memory_thread memory[NB_THREAD];

    j = 0;
    for (i = 0; i < NB_THREAD; i++)
    {
        memory[i].thread = j;
        memory[i].arr_a = &arr_a[j];
        memory[i].arr_b = &arr_b[j];
        j+= (N / NB_THREAD);
    }
    if(launch_thread(memory) == ERR)
    {
        std::cout << "Initialisation host memory thread: ERROR" << std::endl;
        return (ERR);
    }
    return (OK);
}


static int sequential_data_initialisation(float **arr_a, float **arr_b)
{
    int i;

    for (i = 0; i < N; i++)
    {
        (*arr_a)[i] = (float)rand() / (float)RAND_MAX;
        (*arr_b)[i] = (float)rand() / (float)RAND_MAX;
    }
    return (OK);
}

int init_host_memory(float **arr_a, float **arr_b, float **arr_result, int mode)
{
    int return_code;

    *arr_a = (float *)malloc(sizeof(float) * N);
    if (!*arr_a)
        goto err_a;
    *arr_b = (float *)malloc(sizeof(float) * N);
    if (!*arr_b)
        goto err_b;
    *arr_result = (float *)malloc(sizeof(float) * N);
    if (!*arr_result)
        goto err_result;
    
    if (mode == MODE_SEQ)
        return_code = sequential_data_initialisation(arr_a, arr_b);
    else if (mode == MODE_THREAD)
        return_code = thread_data_initialisation(*arr_a, *arr_b);
    else
        return_code = ERR;
    if (return_code == ERR)
        goto err_result;
    
    std::cout << "Initialisation hostss memory: SUCCES" << std::endl;
    return (OK);

    err_result:
        perror("Malloc error arr_result");
        free(*arr_a);
        free(*arr_b);
    err_b:
        perror("Malloc error arr_b");
        free(*arr_a);
    err_a:
        perror("Malloc error arr_a");
    return (ERR);
}