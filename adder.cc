#include <iostream>

template<typename T>
T adder(T v)
{
  return v;
}

template<typename T, typename... Args>
T adder(T first, Args... args)
{
  return first + adder(args...);
}

int main()
{
  long sum = adder(1, 2, 4, 8, 7);
  std::cout << "1 + 2 + 4 + 8 + 7 = " << sum << "\n";
  return 0;
}
