#include <iostream>
#include <array>

using namespace std;

template <size_t D> void print_hypercube(double* ls, size_t n) {
  double dl = *ls / static_cast<double>(n);
  ++ls;
  for (size_t i = 0; i < n; ++i) {
    cout << dl * i + dl / 2.0 << '\n'; 
    print_hypercube<D-1>(ls, n);
  }
}

template <> void print_hypercube<1>(double* ls, size_t n) {
  double dl = *ls / static_cast<double>(n);
  for (size_t i = 0; i < n; ++i) cout << dl * i + dl / 2.0 << '\n'; 
}

int main() {
  double ls[] = { 1.0, 1.0 };
  print_hypercube<1>(ls, 4);

  cout << "\n\n";

  print_hypercube<2>(ls, 2);

  return 0;
}
