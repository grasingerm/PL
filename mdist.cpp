#include <random>
#include <iostream>

using namespace std;

int main() {
  default_random_engine generator1;
  default_random_engine generator2;
  default_random_engine generator3;
  default_random_engine generator4;
  default_random_engine generator5;
  default_random_engine generator6;
  normal_distribution<double> dist1(0.0, 2.0);
  normal_distribution<double> dist2(0.0, 2.0);
  normal_distribution<double> dist3(0.0, 2.0);
  normal_distribution<double> dist4(0.0, 2.0);
  normal_distribution<double> dist5(0.0, 2.0);
  normal_distribution<double> dist6(0.0, 2.0);

  cout << "generator1\n";
  for (unsigned k = 0; k < 10; ++k) 
    cout << dist1(generator1) << ", " << dist2(generator1) << ", " 
         << dist3(generator1) << '\n';
  cout << '\n';

  cout << "dist4\n";
  for (unsigned k = 0; k < 10; ++k) 
    cout << dist4(generator2) << ", " << dist4(generator3) << ", " 
         << dist4(generator4) << '\n';
  cout << '\n';

  cout << "5,5; 6,6\n";
  for (unsigned k = 0; k < 10; ++k) 
    cout << dist5(generator5) << ", " << dist6(generator6) << '\n';
  cout << '\n';

  return 0;
}
