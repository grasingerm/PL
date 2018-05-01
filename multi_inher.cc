#include <iostream>

using namespace std;

class interface {
public:
  void foo() { _foo(); }
  void bar() { _bar(); }
private:
  virtual void _foo()=0;
  virtual void _bar()=0;
};

class foo_impl : virtual public interface {
private:
  void _foo() { cout << "foo_impl::foo()\n"; }
};

class bar_impl : virtual public interface {
private:
  void _bar() { cout << "bar_impl::bar()\n"; }
};

class foobar : public foo_impl, public bar_impl {
};

int main() {
  foobar fb;
  fb.foo();
  fb.bar();

  return 0;
}
