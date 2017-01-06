#include <iostream>
#include <functional>

using namespace std;

template <class F, class T> void forward(F f, T t) {
  f(t);
}

class myfunctor {
public:
  double x;
  myfunctor(double x) : x(x) {}
  template <class T> void operator()(T t);
};

template <class T> void myfunctor::operator()(T t) { 
  cout << "x = " << x << '\n';
  cout << "t = " << t << '\n';
}

int main() {
  myfunctor f1(6.9);
  myfunctor f2(-1.0);

  forward(f1, "ballon");
  forward(f2, "ballon");
  forward(f1, 4);
  forward(f2, 4);

  f1("poop");
  f2(7);

  return 0;
}
