#include <iostream>
#include <array>
#include <functional>

using namespace std;

void apply(int* arr, int (*func)(int), const size_t n) {
  for (size_t i = 0; i < n; ++i)
    arr[i] = func(arr[i]);
}

void print_array(const int* arr, const size_t n) {
  for (size_t i = 0; i < n; ++i) cout << arr[i] << ' ';
}

/*! \brief Print array
 *
 * \param os Output stream
 * \param a Array to print
 * \return Output stream
 */
template <typename T, size_t N>
ostream &operator<<(ostream &os, array<T, N> a) {
  auto aiter = a.cbegin();
  os << '[' << *aiter;
  for (++aiter; aiter != a.cend(); ++aiter)
    os << ' ' << *aiter;
  os << ']';
  return os;
}

template <typename T, size_t N> 
std::array<T, N> tapply(std::function<T(T)> f, const std::array<T, N> &vals) {
  std::array<T, N> retval;
  for (size_t i = 0; i < N; ++i) retval[i] = f(vals[i]);
  return retval;
}

template <typename T> T add_3(T x) { return x + 3; }
template <typename T> T twice(T x) { return 2 * x; }
template <typename T> T square(T x) { return x * x; }

double add_4(double x) { return x + 4.0; }
double cube(double x) { return x * x * x; }
double half(double x) { return x / 2.0; }

int main() {
  int (*fp)(int) = &square;
  int xs[] = {1, 2, 6, 21, 4};
  std::array<double, 5> ys = { 6.9, 2.1, 0.45, -2.2, 100.4};

  cout << "This is the array beforehand...";
  print_array(xs, 5);
  cout << '\n';

  apply(xs, fp, 5);

  cout << "This is the array afterward...";
  print_array(xs, 5);
  cout << '\n';

  cout << "add_4 applied\n";
  cout << ys << '\n';
  cout << tapply<double, 5>(add_4, ys) << "\n\n";

  cout << "half applied\n";
  cout << ys << '\n';
  cout << tapply<double, 5>(half, ys) << "\n\n";
  
  cout << "cube applied\n";
  cout << ys << '\n';
  cout << tapply<double, 5>(cube, ys) << "\n\n";

  cout << "x^2 - 4, applied\n";
  cout << ys << '\n';
  cout << tapply<double, 5>([](double x) -> double { return x*x - 4; }, ys) 
       << "\n\n";

  return 0;
}
