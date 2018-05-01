#include <limits>
#include <iostream>

using namespace std;

int main()
{
  double x;
  for (x = 1.0; x <= numeric_limits<double>::max(); x *= 2.0)
    cout << x << '\n';

  cout << "Crazy result: " <<  x << '\n';
  cout << "Max: " << numeric_limits<double>::max() << '\n';

  return 0;
}
