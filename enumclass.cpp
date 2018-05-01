#include <iostream>

enum class test { TEST1, TEST2, TEST3 };

using namespace std;

int main() {
  test t = test::TEST2;
  if (t > test::TEST1) cout << "t > test::TEST2\n";

  return 0;
}
