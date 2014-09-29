# boilerplate CMakeLists.txt

cmake_minimum_required(VERSION 2.8)

project(project_name)

# uncomment to use clang
# set(CC clang)
# set(CXX clang)

# set C++ standard
#set(STDCXX c++14)
set(STDCXX c++1y)
#set(STDCXX c++11)
#set(STDCXX c++0x)

# set flags for warnings, errors, and standards
set(CMAKE_BUILD_TYPE debug)
set(CMAKE_C_FLAGS_DEBUG "-Wall -Wextra -g -std=c99 -pedantic -pedantic-errors")
set(CMAKE_C_FLAGS_RELEASE "-Wall -Wextra -std=c99 -pedantic -pedantic-errors -O3")
set(CMAKE_CXX_FLAGS_DEBUG "-Wall -Wextra -g -std=${STDCXX} -pedantic -pedantic-errors")
set(CMAKE_CXX_FLAGS_RELEASE "-Wall -Wextra -std=${STDCXX} -pedantic -pedantic-errors -O3")

# build directories
set(CMAKE_BINARY_DIR build)
set(EXECUTABLE_OUTPUT_PATH bin)

# include and link directories
# 
# i.e. ...
# include_directories(../src)
# include_directories(../../share)
# link_directories(../src)

# dependencies
add_executable(some_executable some_source_files.cpp)

# link libraries
# target_link_libraries(some_executable some_library)

# uncomment if using the standard c math library
# if (UNIX)
#     target_link_libraries(some_executable m)
# endif (UNIX)

install(TARGETS some_executable DESTINATION bin)
