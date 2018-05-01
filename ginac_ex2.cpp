#include <iostream>
#include <ginac/ginac.h>
using namespace std;
using namespace GiNaC;

int main() {
  symbol a("a"), b("b"), c("c"), d("d");
  symbol x("x"), y("y");
  matrix K = {{a, b}, {c, d}};
  matrix z = {{x},{y}};

  cout << "K = " << K << '\n';
  cout << "z = " << z << '\n';
  
  return 0;
}
