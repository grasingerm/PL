#include <iostream>

class Base
{
  protected:
    int alpha;
  public:
    Base() {}
    Base(int a) : alpha(a) {}
    virtual int da() { return 2*alpha; }
    int db() { return 2; }
};

class Derived : public Base
{
  protected:
    int beta;
  public:
    Derived() {}
    Derived(int a, int b) : beta(b) { alpha = a; }
    virtual int da() { return 2*alpha + beta; }
    int db() { return 2*beta; }
};

using namespace std;

int main()
{
  Base b(2);
  Derived d(3, -1);
  Base* pd = &d;

  cout << "b::da() = " << b.da() << endl;
  cout << "d::da() = " << d.da() << endl;
  cout << "pd::da() = " << pd->da() << endl;
  cout << "b::db() = " << b.db() << endl;
  cout << "d::db() = " << d.db() << endl;
  cout << "pd::db() = " << pd->db() << endl;

  return 0;
}
