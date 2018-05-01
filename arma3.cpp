#include <armadillo>
#include <iostream>
#include <initializer_list>

using namespace std;
using namespace arma;

class test {
public:
  test(initializer_list<initializer_list<int>> is) : is(is) {}
  inline auto& get_is() { return is; }
private:
  Mat<int> is;
};

int main() {
  mat A({ {1.0, -2.0}, {5.6, 2.3} }); 
  Mat<float> B({ {3.0, -2.0}, {5.6, 2.3} }); 
  cout << "A = " << A << '\n';
  cout << "B = " << B << '\n';
  
  test t1({ {3, -2}, {5, 2} }); 
  cout << "t1.get_is() = " << t1.get_is() << '\n';

  return 0;
}
