#include <iostream>

double f (double x, double y)
{
  return (32 + x) / y;
}

int g (int x)
{
  return x+1;
}

int main ()
{
  double a = 3.5;
  double b = 2.3;

  std::cout << f(a,b) << std::endl;
  std::cout << f(1.0,1.0) << std::endl;
  std::cout << f(2.0,2.0) << std::endl;

  std::cout << f(3.0,4.0) << std::endl;
  std::cout << g(9.0) << std::endl;

  return 0;
}
