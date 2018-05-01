#include <iostream>
#include <memory>

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
  std::unique_ptr<Base> pb(new Base);
  std::unique_ptr<Derived> pd(new Derived(4.5));

  g_wrapper(*pd);

  return 0;
}
