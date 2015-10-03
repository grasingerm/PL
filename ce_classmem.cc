#include <array>
#include <iostream>

using namespace std;

class Test
{
private:
  static constexpr unsigned k_ = 9;
  const unsigned yolo;
  double arr[k_];
public:
  static constexpr unsigned k() { return k_; }
  inline unsigned get_yolo() const { return yolo; }
  Test() : yolo(k()) {}
};

int main()
{
  Test t;
  cout << t.get_yolo() << "\n";
  cout << t.k() << "\n";
  return 0;
}
