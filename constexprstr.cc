#include <string>
#include <iostream>

//constexpr std::string v1() { return std::string("0.0.1"); }
//constexpr char* v2() { return "0.0.1"; }
const static std::string v1("0.0.1");
const static char* v2("0.0.1");


using namespace std;

int main()
{
  cout << v1 << '\n';
  cout << v2 << '\n';

  return 0;
}
