#include <iostream>

using namespace std;

int main() {
  double as[] = { 1.1, 2.2, 3.3 };
  double *pa = &as[1];

  for (auto a : as) cout << a << '\n';
  for (auto a : pa) cout << a << '\n';

  return 0;
}
