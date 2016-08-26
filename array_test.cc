#include <iostream>
#include <array>

using namespace std;

template <typename T, size_t N> ostream& operator<<(ostream& os, array<T, N> a) {
  os << "{ ";
  for (const auto& x : a) os << x << ' ';
  os << '}'; 
  return os;
}

template <typename T, size_t N> auto operator-(const array<T, N>& a1, const array<T, N>& a2) {
  array<T, N> retval;
  for (int i = 0; i < N; ++i)
    retval[i] = a1[i] - a2[i];

  return retval;
}

template <typename T, size_t N> auto operator+(const array<T, N>& a1, const array<T, N>& a2) {
  array<T, N> retval;
  for (int i = 0; i < N; ++i)
    retval[i] = a1[i] + a2[i];

  return retval;
}

template <typename T, size_t N> auto dot(const array<T, N>& a1, const array<T, N>& a2) {
  T retval;
  for (int i = 0; i < N; ++i)
    retval += a1[i] * a2[i];

  return retval;
}

int main() {
  array<double, 3> a1 { { 1.5, 2.0, 2.5 } };
  array<double, 3> a2 { { 0.5, 1.5, 2.0 } };

  cout << a1 << '\n';
  cout << a2 << '\n';
  cout << a1 - a2 << '\n';
  cout << a1 + a2 << '\n';
  cout << dot(a1, a2) << '\n';

  return 0;
}
