#include <iostream>
#include <iomanip>

int main() {
  int *a = new int(3);
  std::cout << "a = " << std::setw(11) << *a << " @ " << a << '\n';
  delete a;
  std::cout << "a = 'undefined' @ " << a << '\n';
  std::cout << "NULL = " << NULL << '\n';

  return 0;
}
