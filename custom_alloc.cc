#include <iostream>
#include <memory>
#include <vector>

using namespace std;

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

  unique_ptr<void> sp_mem_pool(::operator new(n * max_class_hierarchy_size()));

  Base* mem_pool = static_cast<Base*>(sp_mem_pool.get());
  vector<Base*> bs(n);

  for (unsigned i = 0; i < n; ++i)
  {
    //bs[i] = mem_pool;
    switch(tps[i])
    {
      case DynamicType::BASE:
      {
        bs[i] = new (mem_pool) Base(xs[i]);
        Base* new_loc_base = static_cast<Base*>(mem_pool);
        new_loc_base++;
        mem_pool = static_cast<Base*>(new_loc_base);
        //bs[i] = new Base(xs[i]);
        break;
      }
      case DynamicType::DERIVED:
      {
        bs[i] = new (mem_pool) Derived(xs[i], ys[i]);
        Derived* new_loc_derived = static_cast<Derived*>(mem_pool);
        new_loc_derived++;
        mem_pool = static_cast<Base*>(new_loc_derived);
        //bs[i] = new Derived(xs[i], ys[i]);
        break;
      }
      default:
        cerr << "Type: " << static_cast<unsigned>(tps[i]) 
             << " not defined. Exitting...\n";
        exit(1);
    }
  }

  for (const auto& b : bs) b->foo();

  return 0;
}
