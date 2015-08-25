#include <array>
#include <iostream>

using namespace std;

class Test
{
private:
  const unsigned yolo;
public:
  static constexpr unsigned k() { return 9; }
  inline unsigned get_yolo() { return yolo; }
  Test() : yolo(k()) {}
};

int main()
{
  Test t;
  cout << t.get_yolo() << "\n";
  cout << t.k() << "\n";
  return 0;
}
