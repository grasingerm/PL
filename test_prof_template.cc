#include <iostream>
#include <chrono>
#include <ctime>
#include <tuple>
#include <functional>

template<typename Result, typename ...Sig>
std::tuple<Result, std::chrono::duration<double> >
//profile(const std::function<Result(Sig...)> &f, Sig... args)
profile(Result (*f)(Sig...), Sig... args)
{
  std::chrono::time_point<std::chrono::high_resolution_clock> start, end;
  start = std::chrono::high_resolution_clock::now();
  Result result = f(args...);
  end = std::chrono::high_resolution_clock::now();

  return std::tuple<Result, std::chrono::duration<double>> (result, end-start);
}

#include <cmath>

double func(int a, int b, int c)
{
  double sum = 0, temp;
  for (int i = a; i < b; ++i)
  {
    temp = pow(i, c);
    sum += temp;
    std::cout << i << ": " << temp << " -> " << sum << "\n";
  }
  return sum;
}

using namespace std;

int main()
{
  double res;
  chrono::duration<double> time_elapsed;
  auto prof_result = profile(func, 1, 5, 5);
  tie (res, time_elapsed) = prof_result;
  
  cout << "f(1, 5, 5) = " << res << "\n"
       << "Time elapsed: " << time_elapsed.count() << "\n";

  prof_result = profile(func, -2, 121, 7);
  tie (res, time_elapsed) = prof_result;
  
  cout << "f(-2, 121, 7) = " << res << "\n"
       << "Time elapsed: " << time_elapsed.count() << "\n";

  return 0;
}
