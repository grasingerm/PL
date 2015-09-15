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
  void foo() const { cout << "Derived::foo() = \n"; }
};

constexpr size_t max_class_hierarchy_size()
{
  return (sizeof(Base) > sizeof(Derived)) ? sizeof(Base) : sizeof(Derived);
}

enum class DynamicType : unsigned { BASE, DERIVED };

int main()
{
  const static unsigned int n = 5;
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
        bs[i] = main_mem_pool.allocate<Base>();
        break;
      }
      case DynamicType::DERIVED:
      {
        bs[i] = main_mem_pool.allocate<Derived>();
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
