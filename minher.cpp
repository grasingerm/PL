#include <iostream>

using namespace std;

/*
class Base {
public:
  double h() { return f() + g(); }
private:
  virtual double f()=0;
  virtual double g()=0;
};
*/

class DerivedX {
public:
  DerivedX(double x) : x(x) {}
  double f() { return 2.0 * x; }
private:

  double x;
};

class DerivedY {
public:
  DerivedY(double y) : y(y) {}
  double g() { return -3.0 / y; }
private:

  double y;
};

class Derived : public DerivedX, public DerivedY {
public:
  Derived(double x, double y) : DerivedX(x), DerivedY(y) {}
  double h() { return f() + g(); }
};

int main() {
  Derived d(2.4, 1.0);
  cout << d.h() << '\n';

  return 0;
}
