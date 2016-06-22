#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int main()
{
  vector<double> v1 { {-1.1, 0.0, 1.1} };
  vector<double> v2 { {-2.2, 0.0, 2.2} };

  cout << "Before swapping data...\n";

  cout << "v1: ";
  for (const auto& e : v1) cout << e << " ";
  cout << "\n";

  cout << "v2: ";
  for (const auto& e : v2) cout << e << " ";
  cout << "\n";

  v1.swap(v2);

  cout << "After swapping data...\n";

  cout << "v1: ";
  for (const auto& e : v1) cout << e << " ";
  cout << "\n";

  cout << "v2: ";
  for (const auto& e : v2) cout << e << " ";
  cout << "\n";

  double a1[] = {-1.3, 0.0, 1.3};
  double a2[] = {-2.6, 0.9, 2.6};

  cout << "Before swapping data...\n";

  cout << "a1: ";
  for (const auto& e : a1) cout << e << " ";
  cout << "\n";

  cout << "a2: ";
  for (const auto& e : a2) cout << e << " ";
  cout << "\n";

  swap(a1, a2);

  cout << "After swapping data...\n";

  cout << "a1: ";
  for (const auto& e : a1) cout << e << " ";
  cout << "\n";

  cout << "a2: ";
  for (const auto& e : a2) cout << e << " ";
  cout << "\n";

  return 0;
}
