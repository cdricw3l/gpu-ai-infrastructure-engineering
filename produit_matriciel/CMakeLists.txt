cmake_minimum_required(VERSION 4.2.3)

project(gpu_programming LANGUAGES HIP)


add_executable(image_processing)

set (CMAKE_C_FLAGS "-Werror -Wextra -Wall")

message("flags: ${CMAKE_C_FLAGS}")

target_sources(image_processing
    PRIVATE 
        main.hip
    

)
