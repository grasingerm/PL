// Multi-dimensional array as shown at:
// http://cpptruths.blogspot.com/2011/10/multi-dimensional-arrays-in-c11.html
// and authored by: Sumant Tambe

#ifndef __MDARR__
#define __MDARR__

#include <array>

template <class T, size_t I, size_t... J>
struct mdarr
{
  using nested = typename mdarr<T, J...>::type;
  // typedef typename MultiDimArray<T, J...>::type Nested;
  using type = std::array<nested, I>;
  // typedef std::array<Nested, I> type;
};
 
template <class T, size_t I>
struct mdarr<T, I> 
{
  using type = std::array<T, I>;
  // typedef std::array<T, I> type;
};

#endif // __MDARR__