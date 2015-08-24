#include <iostream>

class Base
{
public:
  Base(int initial_value = 0) : x(initial_value) {}
  Base& operator=(const Base& rhs)
  {
    if (this == &rhs) return *this;

    x = rhs.x;
    
    return *this;
  }

protected:
  int x;
};

class Derived : public Base
{
public:
  Derived(int initial_value) : Base(initial_value), y(initial_value) {}

  Derived& operator=(const Derived& rhs)
  {
    if (this == &rhs) return *this;

    Base::operator=(rhs);
    y = rhs.y;

    return *this;
  }

  friend std::ostream& operator<< (std::ostream& out, const Derived& d);

private:
  int y;
};

std::ostream& operator<< (std::ostream& out, const Derived& d)
{
  out << "(x, y) = (" << d.x << ", " << d.y << ")";
  return out;
}

using namespace std;

int main()
{
  Derived d1(0);
  Derived d2(1);

  d1 = d2;

  //cout << "Without base class assignment operator...\n";
  cout << "With base class assignment operator...\n";
  cout << d1 << "\n" << d2 << "\n";

  return 0;
}
