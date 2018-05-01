#include <iostream>
#include <array>
#include <utility>

using namespace std;

int main() {
  array<double, 4> a1 { {1.1, 1.2, 1.3, 1.4} };
  array<double, 4> a2 { {2.1, 2.2, 2.3, 2.4} };

  cout << "a1 = ";
  for (const auto& e : a1) cout << e << ' ';
  cout << '\n';

  cout << "a2 = ";
  for (const auto& e : a2) cout << e << ' ';
  cout << '\n';

  cout << "a1 = move(a2)\n";
  a1 = move(a2);
  cout << "a1 = ";
  for (const auto& e : a1) cout << e << ' ';
  cout << '\n';

  return 0;
}
