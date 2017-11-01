#include <iostream>

using namespace std;

int main() {
  auto lambda = []() {
    cout << "this is a lambda\n";
  };

  double x = 3.4;
  auto& i = x;

  lambda();

  cout << i << '\n';

  return 0;
}
