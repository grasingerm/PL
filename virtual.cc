#include <iostream>

using namespace std;

class A {
public:
  A() { fn(); }

  virtual void fn() { _n = 1; }
  int getn() { return _n; }

protected:
  int _n;
};

class B : public A {
public:
  B() : A() {}

  virtual void fn() { _n = 2; }
};

class Base {
public:
  Base() { f(); }
  virtual void f() { std::cout << "Base" << std::endl; }
};

class Derived : public Base {
public:
  Derived() : Base() { f(); }
  virtual void f() { std::cout << "Derived" << std::endl; }
};

class Derived2 : public Derived {
public:
  Derived2() { f(); }
  virtual void f() { std::cout << "Derived 2" << std::endl; }
};

int main() {
  B b;
  auto n = b.getn();
  cout << "n = " << n << '\n';

  cout << '\n';
  Derived d;
  cout << '\n';

  cout << '\n';
  Derived2 d2;
  cout << '\n';

  return 0;
}
