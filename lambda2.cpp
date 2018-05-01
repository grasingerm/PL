#include <iostream>
#include <functional>
#include <vector>

using namespace std;

template <typename T>
void apply(vector<T>& vals, std::function<T(T)> f) {
  for (auto& val : vals) val = f(val);
}

int main() {
  auto twice = [](double x) { return 2.0*x; };
  vector<double> v1 = { 1.0, 2.0, 3.0 };

  cout << "v1 before apply...\n";
  for (const auto &el : v1) cout << el << ' '; cout << '\n';

  apply<double>(v1, twice);

  cout << "v1 after apply...\n";
  for (const auto &el : v1) cout << el << ' '; cout << '\n';

  return 0;
}
