project(fortran_test Fortran)
cmake_minimum_required(VERSION 3.0)

add_library(liblol SHARED liblol.f)
add_executable(main main.f)
target_link_libraries(main liblol)
