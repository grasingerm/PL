#include <boost/algorithm/string.hpp>
#include <vector>
#include <string>
#include <iostream>

using namespace std;

int main() {
  string str_to_split = "This this a series of words separated by spaces.";
  vector<string> strs;
  boost::split(strs, str_to_split, boost::is_any_of(" "));

  for (const auto &str : strs) cout << str << '\n';

  return 0;
}
