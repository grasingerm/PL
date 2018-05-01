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

constexpr double fpow(double b, unsigned e) {
  return (e == 0) ? 1.0 : b * fpow(b, e-1);
}

using namespace std;

int main() {
  cout << "2^3 = " << power<2, 3>::value << '\n';
  cout << "5^3 = " << power<5, 3>::value << '\n';
  cout << "2^8 = " << power<2, 8>::value << '\n';
  cout << "11^2 = " << power<11, 2>::value << '\n';
  cout << "100^0 = " << power<100, 0>::value << '\n';
  cout << "8^1 = " << power<8, 1>::value << '\n';
  cout << "21^5 = " << power<21, 5>::value << '\n';

  cout << '\n';
  cout << "69.69^2 = " << fpow(69.69, 2) << '\n';
  double y = 3.4 * -6.6;
  cout << "y^1 = " << fpow(y, 1) << '\n';
  cout << "y^3 = " << fpow(y, 3) << '\n';
  cout << "21.1^5 = " << fpow(21.1, 5) << '\n';

  return 0;
}
