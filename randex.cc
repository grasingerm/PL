#include <random>
#include <chrono>
#include <iostream>

using namespace std;

int main() {
  std::default_random_engine generator;
  std::default_random_engine generator2;
  std::normal_distribution<double> dist1(0.0, 0.0);
  std::normal_distribution<double> dist2(0.0, 1.0);

  for (unsigned i = 0; i < 10; ++i) 
    cout << dist1(generator) << ' ' << dist2(generator2) << '\n';

  auto x = random_device()();
  cout << "x = " << x << '\n';
  generator2.seed(x);
  cout << dist2(generator2) << '\n';

  auto now = chrono::high_resolution_clock::now();
  cout << "now.time_since_epoch() = " << now.time_since_epoch().count() << '\n';

  return 0;
}
