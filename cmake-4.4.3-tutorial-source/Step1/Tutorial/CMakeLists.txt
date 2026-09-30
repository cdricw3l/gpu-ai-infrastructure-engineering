add_executable(Tutorial)


target_link_libraries(Tutorial
    PRIVATE 
        MathFunctions
)

target_sources(Tutorial
    PRIVATE
        Tutorial.cxx
)