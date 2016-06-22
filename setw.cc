#include <iostream>
#include <iomanip>

int main()
{
  int x = 100;
  int y = 98679876;

  std::cout << std::setw(5) << x << '\n';
  std::cout << std::setw(5) << y << '\n';

  return 0;
}
