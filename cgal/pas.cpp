#include <iostream>
#include <CGAL/Simple_cartesian.h>

typedef CGAL::Simple_cartesian<double> Kernel;
typedef Kernel::Point_2 Point_2;
typedef Kernel::Segment_2 Segment_2;

using namespace std;

int main() {
  Point_2 p(1, 1), q(10, 10);

  cout << "p = " << p << '\n'; 
  cout << "q = " << q.x() << " " << q.y() << '\n'; 

  cout << "sqdist(p,q) = " << CGAL::squared_distance(p, q) << '\n';

  Segment_2 s(p, q);
  Point_2 m(5, 9);

  cout << "m = " << m << '\n';
  cout << "sqdist(Segment_2(p, q), m) = " << CGAL::squared_distance(s, m) 
       << '\n';

  cout << "p, q, and m ";
  switch (CGAL::orientation(p, q, m)) {
    case CGAL::COLLINEAR: {
      cout << "are collinear\n";
      break;
    }
    case CGAL::LEFT_TURN: {
      cout << "make a left turn\n";
      break;
    }
    case CGAL::RIGHT_TURN: {
      cout << "make a right turn\n";
      break;
    }
  }

  cout << " midpoint(p, q) = " << CGAL::midpoint(p, q) << '\n';
  return 0;
}
