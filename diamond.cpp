#include <iostream>

using namespace std;

class base {
public:
  void foo() { _foo(); }
  void bar() { _bar(); }
private:
  virtual void _foo()=0;
  virtual void _bar()=0;
};

class mid1 : virtual public base {
private:
  virtual void _foo() { cout << "mid1::foo()\n"; }
};

class mid2 : virtual public base {
private:
  virtual void _bar() { cout << "mid2::bar()\n"; }
};

class bottom : public mid1, public mid2 {};

int main() {
  bottom x;
  x.foo();
  x.bar();

  return 0;
}
