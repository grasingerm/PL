#include <iostream>

using namespace std;

void apply(int* arr, int (*func)(int), const size_t n) {
  for (size_t i = 0; i < n; ++i)
    arr[i] = func(arr[i]);
}

void print_array(const int* arr, const size_t n) {
  for (size_t i = 0; i < n; ++i) cout << arr[i] << ' ';
}

int add_3(int x) { return x + 3; }
int double_int(int x) { return 2 * x; }
int square(int x) { return x * x; }

int main() {
  int (*fp)(int) = &square;
  int xs[] = {1, 2, 6, 21, 4};

  cout << "This is the array beforehand...";
  print_array(xs, 5);
  cout << '\n';

  apply(xs, fp, 5);

  cout << "This is the array afterward...";
  print_array(xs, 5);
  cout << '\n';

  return 0;
}
