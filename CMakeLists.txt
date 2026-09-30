cmake_minimum_required(VERSION 4.2.3)

project(gpu_programming LANGUAGE HIP)

set(GPU_TARGETS "gfx1100" CACHE STRING "GPU targets to compile for")
list(APPEND CMAKE_PREFIX_PATH /opt/rocm/hip /opt/rocm)
find_package(hip)

add_executable(gpu_programming)

target_sources(gpu_programming
    PRIVATE 
        main.hip
		gpu/gpu.hip
		cpu/cpu.hip
		tools/time.hip
		tools/display.hip
		memory/memory_clean_check.hip
		memory/init_1D_arr.hip
    PUBLIC 
        FILE_SET HEADERS
        BASE_DIRS
            include
        FILES
            include/gpu_prog.h

)
