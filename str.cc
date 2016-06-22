#include <iostream>
#include <sstream>
#include <string>

using namespace std;

constexpr char* msg = "This is a message that is known at compile time!";
//constexpr string msg2("This is another msg that is known at compile time!");

class Test
{
public:
  void yolo() const noexcept { cout << "yolo\n"; }
};

int main()
{
  Test t;
  t.yolo();

  string s("Hello world!");
  cout << s << "\n";

  int x = 69;
  ostringstream oss;
  oss << "This is a message that you must " << x << "\n";
  oss << "Real hard\n";
  cout << oss.str() << endl;

  cout << msg << "\n";
  //cout << msg2 << "\n";

  return 0;
}
