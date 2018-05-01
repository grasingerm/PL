#include <iostream>

class Base {
  static double x;
};

class A : public Base {
};

class B : public Base {
};

class C : public Base {
};

double Base::x = 1.0;
double A::x = 2.0;
double B::x = 3.0;
double C::x = -4.0;

using namespace std;

int main() {
  cout << Base::x << '\n';
  cout << A::x << '\n';
  cout << B::x << '\n';
  cout << C::x << '\n';

  return 0;
}
