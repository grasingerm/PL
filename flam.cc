#include <iostream>
#include <fstream>

using namespace std;

auto foo() {
  ofstream outfile("test.txt", ofstream::out);
  return [=]() { outfile << "poop\n"; };
}

int main() {
  auto f = foo();
  f();
  f();
  f();

  return 0;
}
