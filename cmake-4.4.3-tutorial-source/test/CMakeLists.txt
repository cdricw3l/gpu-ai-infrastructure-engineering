cmake_minimum_required(VERSION 4.2.3)

set(list_test hello;berlin)

list(APPEND list_test int;the;world)

message("La liste contient ${list_test}")

foreach(x IN LISTS list_test)
    message("Value: ${x}")
endforeach()
