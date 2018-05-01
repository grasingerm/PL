#include <vector>
#include <iostream>

class Test {
public:
  Test(double x) : xs(10, x) {}
  inline void foo() {
    for (const auto x : xs) std::cout << x << '\n';
  }
private:
  std::vector<double> xs;
};

int main() {
  Test t1(6.9);
  t1.foo();

  return 0;
}
