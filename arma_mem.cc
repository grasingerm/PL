#include <iostream>
#include <armadillo>

using namespace std;
using namespace arma;

double mydot(const vec& u, const vec& v)
{
  return dot(u, v);
}

int main()
{
  int a[] = {1, 2, 3};
  double x[] = {1, -2, 3};
  double y[] = {1, 2, -3};
  Col<int> u(a, 3, false, true);
  cout << "u = \n" << u << "\n";
  a[0] = 4;
  cout << "u = \n" << u << "\n";
  double result = mydot(vec(x, 3, false, true), vec(y, 3, false, true));
  cout << "x dot y = " << result << "\n";
  return 0;
}
