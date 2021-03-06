#include <iostream>

struct monomial
{
  double x;
  double c;

  monomial() : x(0.0), c(0.0) {}
  monomial(const double c) : x(0.0), c(c) {}
  monomial(const double x, const double c) : x(x), c(c) {}
};

std::ostream& operator<<(std::ostream& os, const monomial& m) {
  if (m.x != 0) {
    if (m.c > 0) 
      os << m.x << "x + " << m.c;
    else if (m.c < 0)
      os << m.x << "x - " << -m.c;
    else
      os << m.x << "x";
  }
  else
    os << m.c;

  return os;
}

monomial operator+(const monomial& m1, const monomial& m2) {
  monomial retval;
  retval.x = m1.x + m2.x;
  retval.c = m1.c + m2.c;

  return retval;
}

monomial operator-(const monomial& m1, const monomial& m2) {
  monomial retval;
  retval.x = m1.x - m2.x;
  retval.c = m1.c - m2.c;

  return retval;
}

monomial operator-(const monomial& m1) {
  monomial retval;
  retval.x = -m1.x;
  retval.c = -m1.c;

  return retval;
}

monomial operator*(const monomial& m1, const monomial& m2) {
  monomial retval;
  if (m2.x == 0) {
    retval.x = m1.x * m2.c;
    retval.c = m1.c * m2.c;
  }
  else if (m1.x == 0) {
    retval.x = m2.x * m1.c;
    retval.c = m1.c * m2.c;
  }
  else throw std::runtime_error("Cannot multiply two monomials with nonzero x "
                                "coefficients");

  return retval;
}

monomial operator/(const monomial& m1, const monomial& m2) {
  monomial retval;
  if (m2.x == 0) {
    retval.x = m1.x / m2.c;
    retval.c = m1.c / m2.c;
  }
  else if (m1.x == 0) {
    retval.x = m2.x * m1.c;
    retval.c = m1.c * m2.c;
  }
  else throw std::runtime_error("Cannot multiply two monomials with nonzero x "
                                "coefficients");

  return retval;
}

using namespace std;

int main() {
  monomial m1 { 1.1, -3.0 };
  monomial m2 { 2.1, 3.9 };
  monomial m3 { 0.0, 4.5 };
  monomial m4 { 0.0, 2.3 };

  cout << "m1 = " << m1 << '\n';
  cout << "m2 = " << m2 << '\n';
  cout << "m1 + m2 = " << m1 + m2 << '\n';
  cout << "m2 + m1 = " << m2 + m1 << '\n';
  cout << "m1 - m2 = " << m1 - m2 << '\n';
  cout << "m2 - m1 = " << m2 - m1 << '\n';
  cout << "m3 * m2 = " << m3 * m2 << '\n';
  cout << "m2 * m4 = " << m2 * m4 << '\n';
  cout << "m1 - m4 = " << m1 - m4 << '\n';
  cout << "m1 * m3 = " << m1 * m3 << '\n';
  cout << "m4 * m3 = " << m4 * m3 << '\n';
  cout << "-m1 = " << -m1 << '\n';
  cout << "-m2 = " << -m2 << '\n';
  cout << "-m3 = " << -m3 << '\n';
  cout << "-m4 = " << -m4 << '\n';
  cout << "m1 + 1.0 = " << m1 + 1.0 << '\n';
  cout << "m2 + 2.0 = " << m2 + 2.0 << '\n';
  cout << "m2 - 2.0 = " << m2 - 2.0 << '\n';
  cout << "m3 * 3.0 = " << m3 * 3.0 << '\n';
  cout << "m4 / 1.2 = " << m4 / 1.2 << '\n';
  cout << "m1 * 3.0 = " << m1 * 3.0 << '\n';
  cout << "m2 / 1.2 = " << m2 / 1.2 << '\n';

  return 0;
}
