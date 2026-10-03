cmake_minimum_required(VERSION 4.2.3)

project(gpu_programming)


add_executable(image_processing)
set (CMAKE_CXX_FLAGS "-Werror -Wextra -Wall -g")

message("flags: ${CMAKE_CXX_FLAGS}")

add_subdirectory(Matrix_2d)

target_sources(image_processing
    PRIVATE 
        main.cxx
)

target_link_libraries(image_processing
    PRIVATE 
        Matrix_2d
)