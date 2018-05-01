#include <iostream>
#include <cmath>
#include <array>

int main() {
  std::array<double, 12> ys { 0.0 }; 

  #pragma omp parallel for
  for (int x = 2; x < 12; x += 2) {
    const double y = std::sqrt(x + 3);
    ys[x] = y;
  }

  for (auto y : ys) std::cout << y << '\n';

  return 0;
}
