#include <iostream>
#include <stdexcept>

using namespace std;

class Base {
public:
  void yolo() { _yolo(); }
private:
  virtual void _yolo()=0;
};

class Derived1 : public Base {
private:
  void _yolo() { std::cout << "Derived1 yolo()\n"; }
public:
  void yolo2() { std::cout << "Derived1 yolo2()\n"; }
};

class Derived2 : public Base {
private:
  void _yolo() { std::cout << "Derived2 yolo()\n"; }
};

int main() {
  Derived1 d1;
  Derived2 d2;
  Base* b1 = &d1;
  Base* b2 = &d2;
  b1->yolo();
  b2->yolo();

  const auto d1d = dynamic_cast<Derived1*>(b1);
  if (d1d != nullptr) d1d->yolo2();
  else cout << "Could not downcast b1 to Derived1*\n";

  const auto d2d = dynamic_cast<Derived1*>(b2);
  if (d2d != nullptr) d2d->yolo2();
  else cout << "Could not downcast b2 to Derived1*\n";

  throw std::logic_error("This is a fucking logic error");

  return 0;
}
