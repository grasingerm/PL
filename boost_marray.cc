#include "boost/multi_array.hpp"
#include <iostream>
#include <cstdlib>
#include <cassert>

int main()
{
  using arr3d_t = boost::multi_array<double, 3>;
  using arr3d_idx_t = arr3d_t::index;
  arr3d_t A(boost::extents[3][4][2]);

  for(arr3d_idx_t i = 0; i < 3; ++i)
    for(arr3d_idx_t j = 0; j < 4; ++j)
      for(arr3d_idx_t k = 0; k < 2; ++k)
        A[i][j][k] = rand();

  std::cout << "Boost indexing...\n";
  for(arr3d_idx_t i = 0; i < 3; ++i)
    for(arr3d_idx_t j = 0; j < 4; ++j)
      for(arr3d_idx_t k = 0; k < 2; ++k)
        std::cout << "(" << i << ", " << j << ", " << k << ") = "
                  << A[i][j][k] << "\n";

  //std::cout << "\nC++11 range based...\n";
  //for(const auto& a : A) std::cout << a << "\n";

  boost::array<arr3d_t::index, 3> idx = {{0,0,0}};
  A(idx) = 3.14;
  assert(A[0][0][0] == 3.14);

  using range = boost::multi_array_types::index_range;
  arr3d_t::array_view<3>::type myview = A[ boost::indices[range(0,2)]
                                                         [range(1,3)]
                                                         [range(0,4,2)]];
  for (arr3d_idx_t i = 0; i < 2; ++i)
    for (arr3d_idx_t j = 0; j < 2; ++j)
      for (arr3d_idx_t k = 0; k < 2; ++k)
        A[i][j][k] = 0.0;

  std::cout << "Boost indexing...\n";
  for(arr3d_idx_t i = 0; i < 3; ++i)
    for(arr3d_idx_t j = 0; j < 4; ++j)
      for(arr3d_idx_t k = 0; k < 2; ++k)
        std::cout << "(" << i << ", " << j << ", " << k << ") = "
                  << A[i][j][k] << "\n";

  return 0;
}
