#include <iostream>
#include <vector>
#include <algorithm>
#include <cassert>
#include <limits>
#include "ballin_prof.hh"

using namespace std;

//! Sieve of Eratosthenes
//!
//! \param    le    Find primes less than or equal to le
//! \return         Flags, true indicates prime
std::vector<bool> soe(const unsigned le) {
  std::vector<bool> pflags(le+1);
  std::fill(pflags.begin(), pflags.begin()+1, false);
  std::fill(pflags.begin()+2, pflags.end(), true);

  unsigned q, p = 2;
  while (p*p <= le) {
    q = p;
    while (p*q <= le) {
      pflags[p*q] = false;
      ++q;
    }
    while (!pflags[++p]);
  }

  return pflags;
}

//! Find the greatest prime factor of an unsigned integer
//!
//! \param    n   Unsigned integer
//! \return       Greatest prime factor
unsigned gpf(unsigned n) {
  std::vector<bool> pflags = soe(n);

  if (pflags[n])
    return n;
  else {
    unsigned p1 = 2, p = 2;
    while (p < n) {
      if (n % p == 0) {
        n = n / p;
        if (pflags[n])
          return n;
        else
          p1 = p;
      }
      else
        while (!pflags[++p]);
    }
    return p1;
  }
}

const static std::vector<int> _plt1000 {{ 2, 3, 5, 7, 11, 13, 17, 19, 
                                     23, 29, 31, 37, 
                                     41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 
                                     89, 97, 101, 103, 107, 109, 113, 127, 131, 
                                     137, 139, 149, 151, 157, 163, 167, 173, 179, 
                                     181, 191, 193, 197, 199, 211, 223, 227, 229, 
                                     233, 239, 241, 251, 257, 263, 269, 271, 277, 
                                     281, 283, 293, 307, 311, 313, 317, 331, 337, 
                                     347, 349, 353, 359, 367, 373, 379, 383, 389, 
                                     397, 401, 409, 419, 421, 431, 433, 439, 443, 
                                     449, 457, 461, 463, 467, 479, 487, 491, 499, 
                                     503, 509, 521, 523, 541, 547, 557, 563, 569, 
                                     571, 577, 587, 593, 599, 601, 607, 613, 617, 
                                     619, 631, 641, 643, 647, 653, 659, 661, 673, 
                                     677, 683, 691, 701, 709, 719, 727, 733, 739, 
                                     743, 751, 757, 761, 769, 773, 787, 797, 809, 
                                     811, 821, 823, 827, 829, 839, 853, 857, 859, 
                                     863, 877, 881, 883, 887, 907, 911, 919, 929, 
                                     937, 941, 947, 953, 967, 971, 977, 983, 991, 
                                     997 }};

int main() {
  std::vector<bool> _pflags(1001);
  std::fill(_pflags.begin(), _pflags.end(), false);
  for (const auto p : _plt1000) _pflags[p] = true; 

  std::cout << "Testing sieve of Eratosthenes...\n";
  std::vector<bool> tpflags = soe(1000);
  assert(tpflags == _pflags);
  std::cout << "Test passed.\n";

  std::cout << "Primes less than or equal to 1000...\n";
  for (unsigned i = 0; i < tpflags.size(); ++i)
    if (tpflags[i]) std::cout << i << " ";
  std::cout << '\n';

  std::cout << "Greatest prime factor of 13195 is   " << gpf(13195) << '\n';
  std::cout << "Greatest prime factor of 10 is      " << gpf(10) << '\n';
  std::cout << "Greatest prime factor of 5 is       " << gpf(5) << '\n';
  std::cout << "Greatest prime factor of 393 is     " << gpf(393) << '\n';
  std::cout << "Greatest prime factor of 13195*2 is " << gpf(13195*2) << '\n';

  std::cout << "\nProfiled tests...\n";

  random_device rnd_device;
  mt19937 mersenne_engine(rnd_device());
  uniform_int_distribution<unsigned> dist(2, numeric_limits<unsigned>::max());
  auto gen = std::bind(dist, mersenne_engine);

  for (unsigned i = 0; i < 10; ++i) {
    tic();
    unsigned n = gen();
    unsigned f = gpf(n);
    toc();
    cout << "gpf of " << n << " is " << f << '\n';
    cout << '\n';
  }

  return 0;
}
