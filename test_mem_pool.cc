#include <iostream>
#include <vector>
#include <cstdlib>
#include "mem_helpers.hh"

using namespace std;

class Base
{
public:
  virtual ~Base() {}
  virtual void foo() const { cout << "Base::foo()\n"; }
};

class Derived : public Base
{
public:
  ~Derived() {}
  Derived(int x, int y) : Base(x), y_(y) {}
  Derived& operator=(const Derived& d) { Base::operator=(d); y_ = d.y(); return *this; }
  inline int y() const { return y_; }
  void foo() const { cout << "Derived::foo() = " << x() << ", " << y() << "\n"; }
private:
  int y_;
};

constexpr size_t max_class_hierarchy_size()
{
  return (sizeof(Base) > sizeof(Derived)) ? sizeof(Base) : sizeof(Derived);
}

enum class DynamicType : unsigned { BASE, DERIVED };

int main()
{
  const static unsigned int n = 5;
  const int xs[] = {1, 3, 2, -4, 5};
  const int ys[] = {-4, 7, 12, 15, 3};
  const DynamicType tps[] = {DynamicType::BASE, DynamicType::DERIVED, 
                            DynamicType::DERIVED, DynamicType::DERIVED,
                            DynamicType::BASE};
  
  cout << "sizeof(Base) = " << sizeof(Base) << "\n";
  cout << "sizeof(Derived) = " << sizeof(Derived) << "\n";
  cout << "max size() = " << max_class_hierarchy_size() << "\n";

  SimpleMemPool main_mem_pool(n * max_class_hierarchy_size());

  vector<Base*> bs(n);

  for (unsigned i = 0; i < n; ++i)
  {
    switch(tps[i])
    {
      case DynamicType::BASE:
      {
        bs[i] = main_mem_pool.allocate<Base>(xs[i]);
        break;
      }
      case DynamicType::DERIVED:
      {
        bs[i] = main_mem_pool.allocate<Derived>(xs[i], ys[i]);
        break;
      }
      default:
        cerr << "Type: " << static_cast<unsigned>(tps[i]) 
             << " not defined. Exitting...\n";
        exit(1);
    }
  }

  for (const auto& b : bs) b->foo();

  for (int i = n-1; i >= 0; --i) bs[i]->~Base();

  return 0;
}
