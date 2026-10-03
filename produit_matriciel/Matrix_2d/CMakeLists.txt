add_library(Matrix_2d)


target_sources(Matrix_2d
    PRIVATE 
        Matrix_2d.cxx 
    PUBLIC 
    FILE_SET HEADERS
    BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} # <--- AJOUT CRUCIAL ICI
    FILES 
        Matrix_2d.hpp

)
