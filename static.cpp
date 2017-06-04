#include <iostream>

void count() {
  static int counter = 0;
  counter++;
  std::cout << "counter: " << counter << '\n';
}

int main() {
  count();
  count();
  count();
  count();
  count();
  count();

  return 0;
}
