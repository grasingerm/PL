#include <iostream>
#include <vector>
#include <initializer_list>

using namespace std;

template <class T> class test {
public:
  test<T>(initializer_list<initializer_list<T>> xs) {
    for (const auto& row : xs)
      for (const auto& x : row) {
        cout << x << '\n';
        vals.push_back(x);
      }
  }

private:
  std::vector<T> vals;

};

int main() {
  test<float> t1({ {1.1, 2.2}, {3.3, 4.4} });
  test<double> t2({ {1.1, 2.2, -0.3}, {3.3, 4.4, -0.2}, {1.0, 1.0, 1.0} });

  return 0;
}
