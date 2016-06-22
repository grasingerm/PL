#include <iostream>

template<int x, unsigned n>
struct power {
  static constexpr int value = x * power<x, n-1>::value;
};

template<int x>
struct power<x, 0> {
  static_assert(x != 0.0, "");
  static constexpr int value = 1;
};

using namespace std;

int main() {
  cout << "2^3 = " << power<2, 3>::value << '\n';
  cout << "5^3 = " << power<5, 3>::value << '\n';
  cout << "2^8 = " << power<2, 8>::value << '\n';
  cout << "11^2 = " << power<11, 2>::value << '\n';
  cout << "100^0 = " << power<100, 0>::value << '\n';
  cout << "8^1 = " << power<8, 1>::value << '\n';
  cout << "21^5 = " << power<21, 5>::value << '\n';

  return 0;
}
