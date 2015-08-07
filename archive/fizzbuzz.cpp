#include <iostream>
#include <functional>
#include <string>
#include <numeric>
#include <array>
template<typename T,typename R>
struct match_struct{
  T t;
  std::function<R(T&&)> f;
};
template<typename T,typename F
        ,typename R = typename std::result_of<F(T)>::type>
match_struct<T,R> match(T &&t, F f){
  return match_struct<T,R>{std::forward<T>(t),f};
}
template<typename T,typename R>
R pattern(T &&t,R &&d, match_struct<T,R> &&m){
  if( t == m.t)
    return m.f(std::forward<T>(t));
  else
    return d;
}
template<typename T,typename R,typename ...Args>
R pattern(T &&t,R &&d, match_struct<T,R> &&m, Args&& ...rest){
  if( t == m.t)
    return m.f(std::forward<T>(t));
  else
    return pattern(std::forward<T>(t),std::forward<R>(d),std::move(rest)...);
}
template<std::size_t sz>
std::array<unsigned int,sz> range(){
  std::array<unsigned int,sz> arr;
  std::iota(arr.begin(),arr.end(),1);
  return arr;
}
int main(){
  using namespace std;
  auto fizzbuzz = [](int i) {
    auto t = make_tuple(i % 2 == 0, i % 3 == 0);
    return pattern(move(t),std::to_string(i),
      match(make_tuple(true,false), [](auto _){return "fizz"s;}),
      match(make_tuple(false,true), [](auto _){return "buzz"s;}),
      match(make_tuple(true,true) , [](auto _){return "fizzbuzz"s;})
    );
  };
  for(auto i : range<15>()){
    cout << fizzbuzz(i) << endl;
  }
  return 0;
}
