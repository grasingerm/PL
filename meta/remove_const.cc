#include <iostream>
#include <typeinfo>

#define USE_BOOST 1

#ifdef USE_BOOST
#include <boost/type_index.hpp>
#endif

template<class T>
struct remove_const { using type = T; };

template<class U>
struct remove_const<U const> { using type = U; };

int main()
{
  remove_const<const int>::type x = 5;
  x += 4;

  std::cout << "x = " << x << '\n';
  std::cout << "typeid(x) = " << typeid(x).name() << '\n';

#ifdef USE_BOOST
  using boost::typeindex::type_id_with_cvr;
  std::cout << "type_id_with_cvr(x) = " 
            << type_id_with_cvr<decltype(x)>().pretty_name() << '\n';
#endif

  return 0;
}
