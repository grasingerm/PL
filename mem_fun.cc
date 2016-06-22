#include <functional>
#include <vector>
#include <iostream>
#include <algorithm>

class Foo
{
  public:
    Foo() {}
    Foo(int g) : g(g) {}
    virtual ~Foo() {}
    void printg() { std::cout << g << "\n"; }
  private:
    int g;
};

int main()
{
  std::vector<Foo> foos;
  foos.reserve(5);

  foos.emplace_back(1);
  foos.emplace_back(3);
  foos.emplace_back(69);
  foos.emplace_back(-15);
  foos.emplace_back(2);

  std::for_each(foos.begin(), foos.end(), std::mem_fun_ref(&Foo::printg));
  return 0;
}
