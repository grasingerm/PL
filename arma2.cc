#include <armadillo>
#include <iostream>

using namespace std;
using namespace arma;

int main() {
  mat A({ {1.0, -2.0}, {5.6, 2.3} }); 
  cout << "A = " << A << '\n';

  return 0;
}
