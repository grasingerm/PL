cmake_minimum_required(VERSION 2.8)

project(link)

file(GLOB SOURCES *.c)

add_executable(main ${SOURCES})
