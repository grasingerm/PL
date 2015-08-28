#include <iostream>

class Test
{
public:
  const static double arr[3][3];
  inline double yolo() { return _yolo; }
private:
  const static double _yolo;
};

const double Test::arr[3][3] = { { 1.1, 2.2, 3.3 },
                                 { -1.1, -2.2, -3.3 },
                                 { 0.1, 0.2, 0.3 } };
const double Test::_yolo = 3.9;

int main()
{
  Test t;
  for (unsigned i = 0; i < 3; ++i)
    for (unsigned j = 0; j < 3; ++j)
      std::cout << "(" << i << ", " << j << ") = " << t.arr[i][j] << "\n";

  std::cout << "t.yolo() = " << t.yolo() << "\n";

  return 0;
}
