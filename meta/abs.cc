#include <iostream>
#include <climits>

template<int N>
struct mabs {
  static_assert(N != INT_MIN, "argument to mabs is below min");
  static constexpr int value = (N < 0) ? -N : N;
};

int main()
{
  static constexpr int n = -9;
  std::cout << "The absolute value of " << n << " = " << mabs<n>::value
            << '\n';
  std::cout << "Metaprogramming bitches\n";

  return 0;
}
