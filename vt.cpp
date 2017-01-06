#include <iostream>
#include <vector>
#include <string>
#include <initializer_list>

using namespace std;

class manager {
public:
  template <class T> void manage(T &t);
};

template <class T> void manager::manage(T &t) {
  for (auto &x : t.xs) cout << x << '\n';
}

class managed1 {
public:
  managed1(initializer_list<double> xs) : xs(xs) {}

  vector<double> xs;
};

class managed2 {
public:
  managed2(initializer_list<int> xs) : xs(xs) {}

  vector<int> xs;
};

int main() {
  manager man;

  managed1 m1({1.1, 6.9, -3.2, 4.3});
  managed2 m2({2, 3, 4, 5, 9});

  cout << "managing managed1\n";
  man.manage(m1);
  cout << '\n';
  
  cout << "managing managed2\n";
  man.manage(m2);
  cout << '\n';

  return 0;
}
