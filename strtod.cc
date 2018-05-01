#include <cstring>
#include <iostream>
#include <string>

using namespace std;

int main() {
  const char* expr = ".24+sin(3.14)";
  char* endp;

  double d1 = strtod(expr, &endp);
  cout << "d1 = " << d1 << '\n';
  cout << "rest of string: " << endp << '\n';

  cout << "Can I compare a string and a const char?\n";
  string name("yolo");
  if (name == "yolo") cout << "Yes I can!\n";
  else cout << "No NO NO NO\n";

  return 0;
}
