#include <armadillo>
#include <iostream>

const static arma::mat A({{1, 1, 1},{2, 2, 2},{3, 3, 3}});

int main()
{
  arma::mat B({{-3, -3, -3}, {-2, -2, -2}, {-1, -1, -1}});
  arma::mat C = A * B;

  std::cout << "A = \n" << A << "\n";
  std::cout << "B = \n" << B << "\n";
  std::cout << "C = \n" << C << "\n";

  return 0;
}
