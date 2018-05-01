#include <iostream>

template <class T> struct monomial
{
  T x;
  T c;
};

template <class T>
std::ostream& operator<<(std::ostream& os, const monomial<T>& m) {
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

template <class T> monomial<T> operator+(const monomial<T>& m1, const monomial<T>& m2) {
  monomial<T> retval;
  retval.x = m1.x + m2.x;
  retval.c = m1.c + m2.c;

  return retval;
}

template <class T> monomial<T> operator-(const monomial<T>& m1, const monomial<T>& m2) {
  monomial<T> retval;
  retval.x = m1.x - m2.x;
  retval.c = m1.c - m2.c;

  return retval;
}

template <class T> monomial<T> operator-(const monomial<T>& m1) {
  monomial<T> retval;
  retval.x = -m1.x;
  retval.c = -m1.c;

  return retval;
}

template <class T> monomial<T> operator*(const monomial<T>& m1, const monomial<T>& m2) {
  monomial<T> retval;
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

template <class T> monomial<T> operator/(const monomial<T>& m1, const monomial<T>& m2) {
  monomial<T> retval;
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
  monomial<double> m1 { 1.1, -3.0 };
  monomial<double> m2 { 2.1, 3.9 };
  monomial<double> m3 { 0.0, 4.5 };
  monomial<double> m4 { 0.0, 2.3 };

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

  return 0;
}
