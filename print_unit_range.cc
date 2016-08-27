#include <iostream>

using namespace std;

template <size_t N> void print_unit_range() {
  for (unsigned i = 0; i < N; ++i) cout << i << '\n';
}

int main() {

  print_unit_range<4>();
  print_unit_range<14>();

  return 0;
}
