#include <vector>
#include <iostream>

class Foo {
public:
  Foo(double x, double y) : x(x), y(y) {}
  void foo() const { std::cout << "x = " << x << ", y = " << y << '\n'; }
private:
  double x;
  double y;
};

using namespace std;

int main() {
  vector<Foo> fs({
      {1.1, 2.2},
      {-1.1, 8.2},
      {6.1, 9.2},
      });
  for (const auto& f : fs) f.foo();

  return 0;
}
