#include <vector>
#include <iostream>

using namespace std;

void print_vector(const vector<double>& xs) {
  cout << "vector size: " << xs.size() << '\n';
  for (auto x : xs) cout << x << '\n';
}

int main() {
  print_vector({1.1, 2.2, 3.3});
  return 0;
}
