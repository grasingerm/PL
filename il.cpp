#include <initializer_list>
#include <vector>
#include <iostream>

class Test {
public:
  Test(std::initializer_list<double> vals) : vals(vals) {}
  void print_vals() { for (const auto& val : vals) std::cout << val << '\n'; }
private:
  std::vector<double> vals;
};

int main() {
  Test t1({0.1, 0.2, 0.3});
  t1.print_vals();

  return 0;
}
