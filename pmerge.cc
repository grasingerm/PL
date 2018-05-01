#include <cmath>
#include <cstring>
#include <iostream>
#include <algorithm>
#include <random>
#include <iterator>
#include <functional>
#include <vector>
#include <thread>
#include "ballin_prof.hh"

template <typename T> void _merge(const T* fst, const unsigned n1, const T* snd, 
                                  const unsigned n2, T* sorted) {
  unsigned i1 = 0, i2 = 0, i3 = 0;
  while (i1 < n1 || i2 < n2) {
    if (i2 >= n2)
      sorted[i3++] = fst[i1++]; 
    else if (i1 >= n1 || snd[i2] < fst[i1])
      sorted[i3++] = snd[i2++]; 
    else
      sorted[i3++] = fst[i1++]; 
  }
}

template <typename T> void _mergesort(T* to_sort, T* warr, const unsigned n) {
  if (n == 1) {
    return;
  }
  else {
    const unsigned mid = n / 2;
    _mergesort(to_sort, warr, mid);
    _mergesort(to_sort+mid, warr+mid, n-mid);
    _merge(to_sort, mid, to_sort+mid, n-mid, warr);
    std::copy(warr, warr+n, to_sort);
  }
}

template <typename T> void mergesort(T* to_sort, const unsigned n) {
  std::vector<T> temp_memory(n);
  _mergesort<T>(to_sort, temp_memory.data(), n);
}

template <typename T> void _pmerge(const T* fst, const unsigned n1, const T* snd, 
                                   const unsigned n2, T* sorted) {
  unsigned i1 = 0, i2 = 0, i3 = 0;
  while (i1 < n1 || i2 < n2) {
    if (i2 >= n2)
      sorted[i3++] = fst[i1++]; 
    else if (i1 >= n1 || snd[i2] < fst[i1])
      sorted[i3++] = snd[i2++]; 
    else
      sorted[i3++] = fst[i1++]; 
  }
}

template <typename T> void _pmergesort(T* to_sort, T* warr, const unsigned n,
                                       const unsigned N) {
  if (n == 1) {
    return;
  }
  else {
    const unsigned mid = n / 2;
    if (N > 0) {
      std::thread left  (_pmergesort<T>, to_sort, warr, mid, N-2);
      std::thread right (_pmergesort<T>, to_sort+mid, warr+mid, n-mid, N-2);
      left.join();
      right.join();
    }
    else {
      _mergesort<T>(to_sort, warr, mid);
      _mergesort<T>(to_sort+mid, warr+mid, n-mid);
    }
    _pmerge<T>(to_sort, mid, to_sort+mid, n-mid, warr);
    std::copy(warr, warr+n, to_sort);
  }
}

template <typename T> void pmergesort(T* to_sort, const unsigned n,
                                      const unsigned N = 8) {
  std::vector<T> temp_memory(n);
  _pmergesort<T>(to_sort, temp_memory.data(), n, N);
}

template <typename T> void print_array(const T* arr, const unsigned n) {
  for (unsigned i = 0; i < n-1; ++i) std::cout << arr[i] << ", ";
  std::cout << arr[n-1] << '\n';
}

using namespace std;

int main() {
  random_device rnd_device;
  mt19937 mersenne_engine(rnd_device());
  uniform_int_distribution<int> dist(-100, 100);

  auto gen = std::bind(dist, mersenne_engine);
  vector<int> rvec(50000);
  generate(begin(rvec), end(rvec), gen);

  vector<int> svec1(rvec);
  vector<int> svec2(rvec);
  vector<int> svec3(rvec);

  cout << "Original, random array\n";
  print_array(rvec.data(), rvec.size());

  cout << "Mergesort without threading...\n";
  tic();
  mergesort(svec1.data(), svec1.size());
  toc();
  print_array(svec1.data(), 15);
  std::cout << "...\n";

  cout << "Mergesort with 8 threads...\n";
  tic();
  pmergesort(svec2.data(), svec2.size());
  toc();
  print_array(svec2.data(), 15);
  std::cout << "...\n";

  cout << "Mergesort with 4 threads...\n";
  tic();
  pmergesort(svec3.data(), svec3.size(), 4);
  toc();
  print_array(svec3.data(), 15);
  std::cout << "...\n";

  cout << "Mergesort with 2 threads...\n";
  tic();
  pmergesort(svec3.data(), svec3.size(), 2);
  toc();
  print_array(svec3.data(), 15);
  std::cout << "...\n";

  return 0;
}
