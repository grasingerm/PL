#include <iostream>
#include <string>

using namespace std;

int main () {
  string name;

  cout << "Please enter your name: ";
  getline (cin, name);
  if (name.back() == '\n') cout << "It has a newline\n";
  cout << "name.length() = " << name.length() << '\n';
  cout << "name.empty() = " << name.empty() << '\n';
  cout << "Hello, " << name << '\n';

  return 0;
}
