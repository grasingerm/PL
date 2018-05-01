#include <iostream>
#include <vector>
#include <cstdlib>

using namespace std;

// make memory pool usage more explicit
using MemPool = std::vector<char>;

class Base
{
public:
  virtual ~Base() {}
  Base(int x) : x_(x) {}
  Base& operator=(const Base& b) { x_ = b.x(); return *this; }
  inline int x() const { return x_; }
  virtual void foo() const { cout << "Base::foo() = " << x() << "\n"; }
private:
  int x_;
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

  MemPool main_mem_pool;
  main_mem_pool.reserve(n * max_class_hierarchy_size());

  void* mem_pool_init = static_cast<void*>(main_mem_pool.data());
  Base* mem_pool_ptr = static_cast<Base*>(mem_pool_init);
  vector<Base*> bs(n);

  for (unsigned i = 0; i < n; ++i)
  {
    bs[i] = mem_pool_ptr;
    switch(tps[i])
    {
      case DynamicType::BASE:
      {
        Base* new_loc_base = static_cast<Base*>(mem_pool_ptr);
        new (new_loc_base) Base(xs[i]);
        new_loc_base++;
        mem_pool_ptr = static_cast<Base*>(new_loc_base);
        break;
      }
      case DynamicType::DERIVED:
      {
        Derived* new_loc_derived = static_cast<Derived*>(mem_pool_ptr);
        new (new_loc_derived) Derived(xs[i], ys[i]);
        new_loc_derived++;
        mem_pool_ptr = static_cast<Base*>(new_loc_derived);
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
