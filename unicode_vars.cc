#include <iostream>

using namespace std;

inline char poop$() { return 'p'; }

int main() {
  double σ = 1.3;
  double ε = 2.2;

  cout << σ << '\n';
  cout << ε << '\n';
  cout << "σ * ε = " << σ * ε << '\n';
  cout << poop$() << '\n';

  return 0;
}
