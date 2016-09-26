#include <random>
#include <iostream>

using namespace std;

int main() {
  std::default_random_engine generator;
  std::normal_distribution<double> dist1(0.0, 0.0);
  std::normal_distribution<double> dist2(0.0, 1.0);

  for (unsigned i = 0; i < 10; ++i) 
    cout << dist1(generator) << ' ' << dist2(generator) << '\n';

  return 0;
}
