#include <iostream>
#include <iomanip>
#include <array>
#include <set>
#include <cmath>

using namespace std;

static const auto num_primes = size_t{ 25 };
static const auto init_primes = array<unsigned, 2>{ {1, 2} };

int main() {
  cerr << "This program sucks and doesn't yet actually produce prime numbers\n";
  set<unsigned> primes(init_primes.begin(), init_primes.end());
  for (auto i = size_t{ init_primes.size() }; i < num_primes; ++i) {
    unsigned new_prime = 1;
    for (const auto prime : primes) new_prime *= prime;
    primes.insert(++new_prime);
  }

  size_t n = 0;
  size_t col1_width = static_cast<size_t>(ceil(log10(num_primes)));
  for (const auto prime : primes) 
    cout << setw(col1_width) << ++n << ": " << prime << '\n';

  return 0;
}
