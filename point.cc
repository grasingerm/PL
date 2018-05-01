#include <iostream>

class Point {
public:
  Point(const double x, const double y) : x_(x), y_(y) {}
  const Point operator=(const Point&);
  inline double& x() { return x_; }
  inline const double& x() const { return x_; }

  inline double& y() { return y_; }
  inline const double& y() const { return y_; }

private:
  double x_;
  double y_;
};

Point operator+(const Point& p1, const Point& p2) {
  return Point(p1.x() + p2.x(), p1.y() + p2.y());
}

const Point Point::operator=(const Point& p) {
  x_ = p.x();
  y_ = p.y();

  return *this;
}

using namespace std;

int main() {
  Point p1(3.2, 1.2);
  Point p2(-3.3, 4.5);

  Point p3 = p1 + p2;
  Point p4 = p3;

  cout << "p1: " << p1.x() << ", " << p1.y() << '\n';
  cout << "p2: " << p2.x() << ", " << p2.y() << '\n';
  cout << "p3: " << p3.x() << ", " << p3.y() << '\n';
  cout << "p4: " << p4.x() << ", " << p4.y() << '\n';

  return 0;
}
