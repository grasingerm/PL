#include <iostream>
#include <CGAL/Exact_predicates_exact_constructions_kernel.h>
#include <sstream>

using Kernel = CGAL::Exact_predicates_exact_constructions_kernel;
using Point_2 = Kernel::Point_2;

using namespace std;

int main() {
  Point_2 p(0, 0.3), q, r(2, 0.9);
  {
    q = Point_2(1, 0.6);
    cout << (CGAL::collinear(p, q, r) ? "collinear\n" : "not collinear\n");
  }

  {
    istringstream input("0 0.3  1 0.6   2 0.9");
    input >> p >> q >> r;
    cout << (CGAL::collinear(p, q, r) ? "collinear\n" : "not collinear\n");
  }

  {
    q = CGAL::midpoint(p, r);
    cout << (CGAL::collinear(p, q, r) ? "collinear\n" : "not collinear\n");
  }

  return 0;
}
