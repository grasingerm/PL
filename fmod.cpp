#include <cmath>
#include <iostream>

int main() {
  std::cout << fmod(1.1, 6.9) << '\n';
  std::cout << fmod(6.9, 1.1) << '\n';
  std::cout << fmod(2.2, 1.1) << '\n';
  std::cout << fmod(3.31, 1.1) << '\n';
  std::cout << fmod(3.2, 1.1) << '\n';

  return 0;
}
