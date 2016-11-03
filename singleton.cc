#include <iostream>
#include <memory>

using namespace std;

class Singleton {
public:
  static unique_ptr<Singleton> instance;

  Singleton(const double x = 1.0) : x(x) {}

  inline void foo() { cout << "Singleton::foo() => " << x << '\n'; }

  inline static Singleton& get_instance() {
    if (instance == nullptr) instance = make_unique<Singleton>();
    return *instance;
  }

private:
  double x;
};

unique_ptr<Singleton> Singleton::instance = nullptr;

int main() {
  auto s = Singleton::get_instance();
  s.foo();

  return 0;
}
