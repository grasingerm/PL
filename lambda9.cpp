#include <functional>
#include <iostream>

class Test {
public:
  Test() : f([](int x) { return 3.0*x; }) {}
  inline double forward(int x) { return f(x); }
private:
  std::function<double(int)> f;
};

int main() {
  Test t;
  std::cout << t.forward(9) << '\n';

  return 0;
}
