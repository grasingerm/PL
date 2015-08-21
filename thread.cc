#include <iostream>
#include <thread>
#include <functional>
#include <algorithm>

using namespace std;

void foo(int x)
{
  cout << "foo " << x << "...\n";
}

int main()
{
  vector<thread> ts;
  ts.reserve(5);

  for(int i = 0; i < 5; ++i)
    ts.emplace_back(foo, i);

  cout << "main, foo[0, 1, ..., 5] now execute concurrently..\n";

  for_each(ts.begin(), ts.end(), mem_fun_ref(&thread::join));
  cout << "all threads completed\n";

  return 0;
}
