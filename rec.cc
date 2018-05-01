#include <iostream>

int fib(const int n) {
  if (n == 1 || n == 0) return 1;
  return fib(n - 1) + fib(n - 2);
}

int main()
{
  std::cout << "The 5th element in the fibnocci sequence is: " << fib(5) << '\n';
  std::cout << "The 6th element in the fibnocci sequence is: " << fib(6) << '\n';
  return 0;
}
