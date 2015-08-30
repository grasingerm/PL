#include <iostream>
#include <vector>

class Base
{
public:
  Base(const double x) : x(x) {}
  inline double getx() const noexcept { return x; }
  virtual double f() const noexcept { return 2*x; }
protected:
  double x;
};

class Derived : public Base
{
public:
  Derived(const double x, const double y) : Base(x), y(y) {}
  inline double gety() const noexcept { return y; }
  double f() const noexcept { return 2*x + y; }
private:
  double y;
};

int main()
{
  Base b(6.9);
  Derived d(6.9, -1.1);
  std::vector<Base*> bs(2);
  bs[0] = &b;
  bs[1] = &d;

  for(const auto& bi : bs) std::cout << bi->f() << "\n";

  return 0;
}
