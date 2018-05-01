#include <iostream>
#include <functional>
#include <numeric>
#include <vector>

using namespace std;

int main() {
  vector<double> xs({-2.2, 1.0, 1.2, 3.3});

  cout << "numbers: ";
  for (auto& x : xs) cout << x << ' ';
  cout << '\n';

  cout << "product: " 
       << accumulate(xs.begin(), xs.end(), 1.0, multiplies<double>())
       << '\n';
  
  cout << "sum: " 
       << accumulate(xs.begin(), xs.end(), 0.0, plus<double>())
       << '\n';

  cout << "sum+3.4: " 
       << accumulate(xs.begin(), xs.end(), 3.4, plus<double>())
       << '\n';

  cout << "sum 2x: "
       << accumulate(xs.begin(), xs.end(), 0.0, [](double x, double y) {
            return x + 2*y;
           })
       << '\n';

  return 0;
}
