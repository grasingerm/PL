#include <iostream>
#include <CGAL/Simple_cartesian.h>

using Kernel = CGAL::Simple_cartesian<double>;
using Point_2 = Kernel::Point_2;

using namespace std;

int main() {
  {
    Point_2 p(0, 0.3), q(1, 0.6), r(2, 0.9);
    cout << (CGAL::collinear(p, q, r) ? "collinear\n" : "not collinear\n");
  }
  {
    Point_2 p(0, 1.0 / 3.0), q(1, 2.0 / 3.0), r(2, 1.0);
    cout << (CGAL::collinear(p, q, r) ? "collinear\n" : "not collinear\n");
  }
  {
    Point_2 p(0, 0), q(1, 1), r(2, 2);
    cout << (CGAL::collinear(p, q, r) ? "collinear\n" : "not collinear\n");
  }

  return 0;
}
