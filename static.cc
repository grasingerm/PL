#define NDEBUG

#include <iostream>
#include <cassert>

using namespace std;

void func1()
{
#ifndef NDEBUG
  const static unsigned arr[] = {1, 2, 9, 1, 3};
  for (unsigned i = 0; i < 5; ++i) cout << arr[i] << ' ';
#endif
  cout << '\n';
}

void func2()
{
  const static unsigned arr[] = {8, 2, 9, 69, 3};
  for (unsigned i = 0; i < 5; ++i) cout << arr[i] << ' ';
  cout << '\n';
  assert(false);
}

int main()
{
  func1();
  func2();
  return 0;
}
