#include <iostream>
using namespace std;

class Mother
{
public:
  Mother()
    { cout << "Mother: no params" << endl; }
  Mother(int a)
    { cout << "Mother: int param" << endl; }
};

class Daughter : public Mother
{
public:
  Daughter(int a)
    { cout << "Daughter: int param" << endl; }
};

class Son : public Mother
{
public:
  Son(int a) : Mother(a)
    { cout << "Son: int param" << endl; }
};

int main()
{
  Daughter kelly(0);
  Son bud(0);

  return 0;
}
