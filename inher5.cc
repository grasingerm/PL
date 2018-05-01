#include <iostream>

class Base
{
public:
  void f () const { _f(); }
private:
  virtual void _f() const { std::cout << "Base::_f()\n"; }
};

class Derived : public Base
{
public:
  Derived(const double x) : _x(x) {}
  void g () const { std::cout << "Derived::_g() " << _x << "\n"; }
private:
  double _x;
  void _f() const { std::cout << "Derived::_f()\n"; }
};

void g_wrapper(const Base& b)
{
  const Derived& d = static_cast<const Derived&>(b);
  std::cout << "g_wrapper(...)\n";
  d.g();
}

int main()
{
  Base b;
  Derived d(4.5);

  Base* pbb = &b;
  Base* pbd = &d;

  pbb->f();
  pbd->f();
  Derived* pdd = dynamic_cast<Derived*>(pbd);
  pdd->g();
  g_wrapper(d);

  return 0;
}
