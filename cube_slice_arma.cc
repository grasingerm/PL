#include <iostream>
#include <armadillo>

template<typename T> class TD;

using namespace std;
using namespace arma;

int main()
{
  cube c(2, 4, 4);
  c.randu();

  const auto& col = c.subcube(0, 0, 0, 1, 0, 0);
  vec u({1, 1});
  //TD<decltype(col)> coltype;

  cout << "c = \n" << c << "\n";
  cout << "col = \n" << col << "\n";
  vec v(col);
  cout << "v = \n" << v << "\n";
  cout << "v dot u = " << dot(v, u) << "\n";

  return 0;
}
