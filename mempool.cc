#include <vector>
#include <iostream>

class MemPool
{
public:
  MemPool(const std::size_t bytes = 1) : allocated_(0)  
    { mem_.reserve(bytes); internal_ptr_ = raw_ptr(); }
  inline void* raw_ptr() { return static_cast<void*>(mem_.data()); }
  inline std::size_t capacity() const { return mem_.capacity(); }
  template <typename T> T* allocate(T&& rval);
private:
  std::size_t allocated_;
  std::vector<char> mem_;
  void* internal_ptr_;
};

//! allocate in the memory pool
template <typename T> T* MemPool::allocate(T&& rval)
{
  std::size_t to_alloc = sizeof(T);
  if (to_alloc + allocated_ > capacity())
    return nullptr;

  T* temp_ptr = static_cast<T*>(internal_ptr_);
  T* result = new (temp_ptr) T(rval);
  internal_ptr_ = static_cast<void*>(++temp_ptr);
  allocated_ += to_alloc;

  return result;
}

using namespace std;

class Base
{
public:
  virtual ~Base() {}
  Base(const int x) : x_(x) {}
  virtual void foo() const { cout << "Base::foo() = " << x() << '\n'; }
  inline int x() const { return x_; }
private:
  int x_;
};

class Derived: public Base
{
public:
  ~Derived() {}
  Derived(const int x, const double y, const double z) : Base(x), y_(y), z_(z) {}
  void foo() const { cout << "Derived::foo() = " << x() << ", " << y() << ", " 
                          << z() << '\n'; }
  inline double y() const { return y_; }
  inline double z() const { return z_; }
private:
  double y_;
  double z_;
};

int main()
{
  MemPool mp(sizeof(Derived) * 4);
  std::cout << "capacity = " << mp.capacity() << '\n';
  std::cout << "sizeof(Base) = " << sizeof(Base) << '\n';
  std::cout << "sizeof(Derived) = " << sizeof(Derived) << '\n';

  std::vector<Base*> bptrs;
  Base* pbcurr;

  if (pbcurr = mp.allocate(Base(1))) bptrs.push_back(pbcurr);
  if (pbcurr = mp.allocate(Base(2))) bptrs.push_back(pbcurr);
  if (pbcurr = mp.allocate(Derived(-3, 3.4, 2.3))) bptrs.push_back(pbcurr);
  if (pbcurr = mp.allocate(Derived(7, 1.1, 6.9))) bptrs.push_back(pbcurr);
  if (pbcurr = mp.allocate(Derived(1, 0.1, 0.2))) bptrs.push_back(pbcurr);
  if (pbcurr = mp.allocate(Base(1))) bptrs.push_back(pbcurr);
  if (pbcurr = mp.allocate(Base(1))) bptrs.push_back(pbcurr);

  for (const auto& bptr : bptrs) bptr->foo();
  for (int i = bptrs.size()-1; i > 0; --i) bptrs[i]->~Base();

  return 0;
}
