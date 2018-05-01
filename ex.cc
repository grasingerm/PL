#include <iostream>

using namespace std;

struct Qwerty {
  int arr[3];
  const char* name;
};

int main()
{
  Qwerty qs[] = {
    { {0}, "Mouse", },
    { {0}, "Zebra", },
    { {0}, "Bear" }
  };

  cout << qs[1].name[3] << '\n';

  return 0;
}
