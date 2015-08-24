#include "boost/multi_array.hpp"
#include <iostream>
#include <cstdlib>

int main()
{
  using arr3d_t = boost::multi_array<double, 3>;
  using arr3d_idx_t = arr3d_t::index;
  arr3d_t A(boost::extents[3][4][2]);

  for(arr3d_idx_t i = 0; i < 3; ++i)
    for(arr3d_idx_t j = 0; j < 4; ++j)
      for(arr3d_idx_t k = 0; k < 2; ++k)
        A[i][j][k] = rand();

  for(arr3d_idx_t i = 0; i < 3; ++i)
    for(arr3d_idx_t j = 0; j < 4; ++j)
      for(arr3d_idx_t k = 0; k < 2; ++k)
        std::cout << "(" << i << ", " << j << ", " << k << ") = "
                  << A[i][j][k] << "\n";

  return 0;
}
