#include <memory>
#include <iostream>

using namespace std;

int main()
{
  unique_ptr<double> up(nullptr);

  if (up) cout << "Evaluates to true?\n";
  else cout << "Evaluates to false.\n";

  return 0;
}
