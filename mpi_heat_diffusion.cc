#include <algorithm>
#include <iostream>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <mpi.h>

static const auto NX = std::size_t{ 100 };
static const auto left_val = float{ 1.0 };
static const auto right_val = float{ 10.0 };
static const auto num_steps = unsigned{ 10000 };

void initialize(double uk[], double ukp1[], const std::size_t num_points,
                const std::size_t num_procs, const int my_id) {
  for (auto i = std::size_t{ 1 }; i <= num_points; ++i)
    uk[i] = 0.0;

  if (my_id == 0) uk[1] = left_val;
  if (my_id == num_procs - 1) uk[num_points] = right_val;

  std::copy(&uk[1], &uk[num_points], ukp1);
}

void print_values(const double uk[], const unsigned step, const std::size_t
                  num_points, const int my_id) {
  throw "(print_values) not yet implemented.";
}

int main(int argc, char *argv[]) {
  
}
