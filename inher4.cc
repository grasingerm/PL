#include <iostream>

class Base
{
public:
  void f() const noexcept { _f(); }
protected:
  virtual void _f() const noexcept { std::cout << "Base::f()\n"; }
};

class Derived : public Base
{
private:
  virtual void _f() const noexcept { Base::_f(); std::cout << "Derived::f()\n"; }
};

int main()
{
  Base b;
  Derived d;
  Base* pb = &b;
  Base* pd = &d;

  pb->f();
  pd->f();

  return 0;
}
