#include <iostream>
#include <limits>
#include <iomanip>

using namespace std;

int main()
{
  cout << "Double\n";
  cout << setw(20) << "Max precision: " << numeric_limits<double>::epsilon() << "\n";
  cout << setw(20) << "Min value: " << numeric_limits<double>::min() << "\n";
  cout << setw(20) << "Max value: " << numeric_limits<double>::max() << "\n";
  cout << setw(20) << "Max round error: " << numeric_limits<double>::round_error() << "\n";

  cout << "Long double\n";
  cout << setw(20) << "Max precision: " << numeric_limits<long double>::epsilon() << "\n";
  cout << setw(20) << "Min value: " << numeric_limits<long double>::min() << "\n";
  cout << setw(20) << "Max value: " << numeric_limits<long double>::max() << "\n";
  cout << setw(20) << "Max round error: " << numeric_limits<long double>::round_error() << "\n";

  cout << "Long unsigned\n";
  cout << setw(20) << "Max precision: " << numeric_limits<long unsigned>::epsilon() << "\n";
  cout << setw(20) << "Min value: " << numeric_limits<long unsigned>::min() << "\n";
  cout << setw(20) << "Max value: " << numeric_limits<long unsigned>::max() << "\n";
  cout << setw(20) << "Max round error: " << numeric_limits<long unsigned>::round_error() << "\n";

  return 0;
}
