#include <iostream>
#include <algorithm>
#include <vector>

// complexity: up to linear in the distance between first and last: swaps
//             (or moves) elements until all elements have been relocated

int main() {
  static const size_t num_elems = 10;
  static const size_t pivot1 = 3;
  static const size_t pivot2 = 6;
  std::vector<int> v;
  v.reserve(num_elems);

  for (size_t i = 0; i < num_elems; ++i) v.push_back(i);

  std::cout << "v = { ";
  for (const auto vi : v) std::cout << vi << ' ';
  std::cout << "}\n";

  std::cout << "rotating about " << pivot1 << '\n';
  std::rotate(v.begin(), v.begin() + pivot1, v.end());

  std::cout << "v = { ";
  for (const auto vi : v) std::cout << vi << ' ';
  std::cout << "}\n";

  std::cout << "rotating about " << pivot2 << '\n';
  std::rotate(v.begin(), v.begin() + pivot2, v.end());

  std::cout << "v = { ";
  for (const auto vi : v) std::cout << vi << ' ';
  std::cout << "}\n";

  return 0;
}
