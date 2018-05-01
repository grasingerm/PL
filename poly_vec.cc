#include <vector>
#include <iostream>
#include <memory>

class A
{
public:
  virtual void f() const { std::cout << "A::f()\n"; }
};


class B : public A
{
public:
  virtual void f() const { std::cout << "B::f()\n"; }
};


class C : public A
{
public:
  virtual void f() const { std::cout << "C::f()\n"; }
};

int main()
{
  std::vector<std::unique_ptr<A>> v;
  v.reserve(5);
  v.emplace_back(new A());
  v.emplace_back(new B());
  v.emplace_back(new C());
  v.emplace_back(new B());
  v.emplace_back(new C());

  for (const auto &vi : v) vi->f();

  return 0;
}
