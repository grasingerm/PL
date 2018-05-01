cmake_minimum_required(VERSION 2.8)
project(world)

set(CMAKE_CXX_FLAGS "-std=c++14")
set(CMAKE_CXX_FLAGS_DEBUG "-Wall -Wextra -g -pedantic")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

set(CMAKE_C_FLAGS_DEBUG "-Wall -Wextra -g -pedantic")
set(CMAKE_C_FLAGS_RELEASE "-O3")

include_directories(../include)

add_library(world world.cpp)
