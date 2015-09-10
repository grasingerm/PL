#include <iostream>

using namespace std;

class Base {
public:
  inline void foo() const { foo_(); }
private:
  virtual void foo_() const = 0;
};

class Derived : public Base {
private:
  void foo_() const;
};

void Derived::foo_() const
{
  cout << "Derived::foo_()\n";
}

int main() {
  Derived d;
  Base* pd = &d;
  pd->foo();

  return 0;
}
