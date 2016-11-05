#include <cmath>
#include <iostream>

using namespace std;

int main() {
  cout << "-1.2 % 5.2 = " << fmod(-1.2, 5.2) << '\n';
  cout << "24.4 % 7.2 = " << fmod(24.4, 7.2) << '\n';
  cout << "-0.4 % 1.0 = " << fmod(-0.4, 1.0) << '\n';
  cout << "-1.4 % 1.0 = " << fmod(-1.4, 1.0) << '\n';
  cout << "1.4 % 1.0 = " << fmod(1.4, 1.0) << '\n';
  cout << "6.5 % 1.0 = " << fmod(6.5, 1.0) << '\n';

  return 0;
}
