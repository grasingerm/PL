#ifndef MEM_HELPERS_HH
#define MEM_HELPERS_HH

#include <vector>

class SimpleMemPool {
public:
  SimpleMemPool(const std::size_t bytes = 1) : allocated_(0) {
    mem_.reserve(bytes);
    internal_ptr_ = raw_ptr();
  }
  inline void *raw_ptr() { return static_cast<void *>(mem_.data()); }
  inline std::size_t capacity() const { return mem_.capacity(); }
  template <typename T, typename ...Args> T *allocate(Args...);

private:
  std::size_t allocated_;
  std::vector<char> mem_;
  void *internal_ptr_;
};

/*
//! Allocate object in the memory pool
//!
//! \param Rvalue reference for object to store in memory pool
//! \return Pointer to object moved into memory pool
template <typename T> T *SimpleMemPool::allocate(T &&rval) {
  std::size_t to_alloc = sizeof(T);
  if (to_alloc + allocated_ > capacity())
    return nullptr;

  T *temp_ptr = static_cast<T *>(internal_ptr_);
  T *result = new (temp_ptr) T(rval);
  internal_ptr_ = static_cast<void *>(++temp_ptr);
  allocated_ += to_alloc;

  return result;
}*/

//! Allocate object in the memory pool
//!
//! \param Rvalue reference for object to store in memory pool
//! \return Pointer to object moved into memory pool
template <typename T, typename ...Args> 
  T *SimpleMemPool::allocate(Args... args) {
  std::size_t to_alloc = sizeof(T);
  if (to_alloc + allocated_ > capacity())
    return nullptr;

  T *temp_ptr = static_cast<T *>(internal_ptr_);
  T *result = new (temp_ptr) T(args...);
  internal_ptr_ = static_cast<void *>(++temp_ptr);
  allocated_ += to_alloc;

  return result;
}

#endif // MEM_HELPERS_HH
