#include <iostream>

void putsu(const unsigned u) {
  std::cout << "u = " << u << '\n';
  std::cout << "(int)u = " << static_cast<int>(u) << '\n';
}

int main() {
  int x = -3;
  int y = 8;

  putsu(x);
  putsu(-5);
  putsu(8);
  putsu(y);
  putsu(0);

  return 0;
}
