#include <armadillo>
#include <iostream>

const static arma::mat A({{1, 2}, {4, 3}});
inline double a(unsigned i, unsigned j) { return A(i, j); }

using namespace std;

int main()
{
  for (unsigned i = 0; i < 2; ++i)
    for (unsigned j = 0; j < 2; ++j)
      cout << a(i, j) << "\n";

  return 0;
}
