#include "mdarr.h"
#include <iostream>

using namespace std;

int main(void)
{
  mdarr<double, 3, 4> a;
  for (size_t i = 0; i < 3; ++i)
    for (size_t j = 0; j < 4; ++j)
      a[i][j] = -4.0 + i*j;

  for (size_t i = 0; i < 3; ++i)
  {
    for (size_t j = 0; j < 4; ++j)
      cout << a[i][j];
    cout << endl;
  }
}