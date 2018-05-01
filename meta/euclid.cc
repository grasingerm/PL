#include <iostream>

template<unsigned M, unsigned N>
struct gcd {
  static constexpr int value = gcd<N, M%N>::value;
};

template<unsigned M>
struct gcd<M, 0> {
  static_assert(M != 0, "");
  static constexpr int value = M;
};

int main()
{
  static constexpr int n = 8;
  static constexpr int m = 12;

  std::cout << "GCD of " << n << ", " << m << " = " << gcd<n, m>::value << '\n';
  std::cout << "GCD of " << 13 << ", " << 39 << " = " << gcd<13, 39>::value << '\n';
  std::cout << "GCD of " << 2437 << ", " << 19314 << " = " << 
               gcd<2437, 19314>::value << '\n';
  return 0;
}
