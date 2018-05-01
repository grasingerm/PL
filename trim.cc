#include <algorithm>
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

void trim(string& s)
{
  const auto pred = [](const int c) { return isspace(c); };
  auto end_of_leading_ws = find_if_not(s.begin(), s.end(), pred);
  if (end_of_leading_ws != s.end())
    s.erase(s.begin(), end_of_leading_ws);

  const auto beg_of_trailing_ws = find_if_not(s.rbegin(), s.rend(), pred);
  if (beg_of_trailing_ws != s.rend())
    s.erase(beg_of_trailing_ws.base(), s.end());
}


int main()
{
  string s1 = "   This has leading whitespace..\n";
  string s2 = "   This has leading whitespace.. and trailing whitespace  \n";
  trim_leading(s1);
  cout << '[' << s1 << "]\n";

  trim(s2);
  cout << '[' << s2 << "]\n";

  return 0;
}
