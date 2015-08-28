#include <memory>
#include <iostream>

using namespace std;

int main()
{
  unique_ptr<double[]> arr(new double[5]);
  for (unsigned i = 0; i < 5; ++i)
    arr[i] = 1.1 * i;

  for (unsigned i = 0; i < 5; ++i)
    cout << arr[i] << "\n";

  return 0;
}
