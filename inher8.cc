#include <iostream>

class Base {
public:
  void yolo() { _yolo(); }
private:
  virtual void _yolo()=0;
};

class Derived1 : public Base {
private:
  void _yolo() { std::cout << "Derived1 yolo()\n"; }
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

  return 0;
}
