#include <iostream>
#include <string>
#include <cctype>
#include <vector>

using namespace std;

void trim_leading(string& s)
{
  auto siter = s.begin();
  while(isspace(*siter)) siter++;
  s.erase(s.begin(), siter);
}

int main()
{
  string s1 = "   This has leading whitespace..\n";
  trim_leading(s1);
  cout << s1;

  return 0;
}
