#include <iostream>

using namespace std;

class Foo {
public:
  Foo() {}
  void foo() const { cout << "Foo::foo()\n"; }
  void poo() { cout << "Foo::poo()\n"; }
};

int main() {
  const Foo f1;
  Foo f2;

  f1.foo();
  f2.foo();
  
  //f1.poo();
  f2.poo();

  return 0;
}
