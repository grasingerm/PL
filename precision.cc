#include <iostream>
#include <limits>
#include <iomanip>

using namespace std;

int main()
{
  cout << setw(20) << "Max precision: " << numeric_limits<double>::epsilon() << "\n";
  cout << setw(20) << "Min value: " << numeric_limits<double>::min() << "\n";
  cout << setw(20) << "Max value: " << numeric_limits<double>::max() << "\n";
  cout << setw(20) << "Max round error: " << numeric_limits<double>::round_error() << "\n";

  return 0;
}
