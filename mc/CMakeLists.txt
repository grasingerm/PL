# boilerplate CMakeLists.txt

cmake_minimum_required(VERSION 2.8)

project(monte-carlo-parking-lot)

find_package(MPI REQUIRED)

set(STDCXX c++11)
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
include_directories(SYSTEM /usr/local/sprng2.0/include ${MPI_INCLUDE_PATH})
link_directories(/usr/local/sprng2.0/lib)

# dependencies
add_executable(mc_demo mc_demo.c)
add_executable(mcmc_demo mcmc_demo.c)

# link libraries
target_link_libraries(mc_demo ${MPI_C_LIBRARIES} sprng gmp gsl gslcblas)
target_link_libraries(mcmc_demo ${MPI_C_LIBRARIES} sprng gmp gsl gslcblas)

if(MPI_COMPILE_FLAGS)
  set_target_properties(mc_demo PROPERTIES COMPILE_FLAGS "${MPI_COMPILE_FLAGS}")
  set_target_properties(mcmc_demo PROPERTIES COMPILE_FLAGS "${MPI_COMPILE_FLAGS}")
endif()

if(MPI_LINK_FLAGS)
  set_target_properties(mc_demo PROPERTIES LINK_FLAGS "${MPI_LINK_FLAGS}")
  set_target_properties(mcmc_demo PROPERTIES LINK_FLAGS "${MPI_LINK_FLAGS}")
endif()

# uncomment if using the standard c math library
if (UNIX)
  target_link_libraries(mc_demo m)
endif (UNIX)

install(TARGETS mc_demo mcmc_demo DESTINATION bin)
