#include <iostream>
#include <memory>

using namespace std;

struct B
{
  virtual void f() const { cout << "B::f "; }
  void g() const { cout << "B::g "; }
};

struct D : B
{
  void f() const { cout << "D::f "; }
  void g() { cout << "D::g "; }
};

struct DD : D
{
  void f() { cout << "DD::f "; }
  void g() const { cout << "DD:g "; }
};

void call(const B& b)
{
  b.f();
  b.g();
}

int main()
{
  B b;
  D d;
  DD dd;

  call(b);
  call(d);
  call(dd);

  b.f();
  b.g();

  d.f();
  d.g();

  dd.f();
  dd.g();

  cout << endl;

  auto ub = std::unique_ptr<B> (new (typeid(d)));
  call(ub);
  ub->f();
  ub->g();

  cout << endl;

  return 0;
}

