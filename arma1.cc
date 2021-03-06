#include <armadillo>
#include <iostream>

using namespace std;
using namespace arma;

int main()
{
  mat A({{1, 2, 3}, {-1, -2, -3}, {0, 6.9, 7.2}});
  rowvec u({7, 12, -4});
  mat B = A.col(1) * u;
  vec v({0.3, 0.2, 0.6});
  v += (3.0 * A.col(1));
  
  cout << "A = \n" << A << "\n";
  cout << "u = \n" << u << "\n";
  cout << "A[:,1] * u = B = \n" << B << "\n";
  cout << "dot(A[:,2], u) = \n" << dot(A.row(2), u) << "\n";
  cout << "B.row(0) = \n" << B.row(0) << "\n";
  cout << "v = \n" << v << "\n";

  return 0;
}
