#ifndef __BALLINPROF__ 
#define __BALLINPROF__

#include <iostream>
#include <chrono>
#include <ctime>
#include <tuple>
#include <functional>

//! Profile a simple function given a function pointer
//!
//! \param f Function pointer
//! \param args Function arguments
//! \return (function result, function duration)
template<typename Result, typename ...Sig>
std::tuple<Result, std::chrono::duration<double> >
profile(Result (*f)(Sig...), Sig... args)
{
  std::chrono::time_point<std::chrono::high_resolution_clock> start, end;
  start = std::chrono::high_resolution_clock::now();
  Result result = f(args...);
  end = std::chrono::high_resolution_clock::now();

  return std::tuple<Result, std::chrono::duration<double>> (result, end-start);
}

//! Profile a simple function given a functor
//!
//! \param f Functor object
//! \param args Function arguments
//! \return (functor result, function duration)
template<typename Result, typename ...Sig>
std::tuple<Result, std::chrono::duration<double> >
profile(const std::function<Result(Sig...)> &f, Sig... args)
{
  std::chrono::time_point<std::chrono::high_resolution_clock> start, end;
  start = std::chrono::high_resolution_clock::now();
  Result result = f(args...);
  end = std::chrono::high_resolution_clock::now();

  return std::tuple<Result, std::chrono::duration<double>> (result, end-start);
}

#endif // __BALLINPROF__
