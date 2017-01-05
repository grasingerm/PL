#include <iostream>
#include <vector>

using namespace std;

class manager {
  template <class T> void manage<T>(T &t) {
    for (auto &x : t.xs) cout << x << '\n';
  }
};

class managed1 {
public:
  
};
