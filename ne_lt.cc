#include <iostream>
#include <climits>
#include "ballin_prof.hh"

void ne (unsigned long long n)
{
  for (unsigned long long i = 0; i != n; ++i);
}

void lt (unsigned long long n)
{
  for (unsigned long long i = 0; i < n; ++i);
}

int main()
{
  const unsigned long long N = ULLONG_MAX;
  std::cout << "N = " << N << "\n"; 

  const auto& p2 = simple_profile(&lt, N);
  std::cout << "Less than: " << p2.count() << "\n";

  const auto& p1 = simple_profile(&ne, N);
  std::cout << "Not equal: " << p1.count() << "\n";

  return 0;
}
