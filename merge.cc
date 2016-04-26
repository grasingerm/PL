#include <cmath>
#include <cstring>
#include <iostream>
#include <algorithm>
#include <vector>

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
  _mergesort(to_sort, temp_memory.data(), n);
}

template <typename T> void print_array(const T* arr, const unsigned n) {
  for (unsigned i = 0; i < n-1; ++i) std::cout << arr[i] << ", ";
  std::cout << arr[n-1] << '\n';
}

int main() {
  const static int n1 = 2;
  int unsorted1[n1] = {5, 1};

  std::cout << "First array before mergesort\n";
  print_array(unsorted1, n1);
  
  mergesort(unsorted1, n1);

  std::cout << "First array after mergesort\n";
  print_array(unsorted1, n1);

  const static int n2 = 6;
  int unsorted2[n2] = {3, 5, 1, 7, -4, 4};

  std::cout << "Second array before mergesort\n";
  print_array(unsorted2, n2);
  
  mergesort(unsorted2, n2);

  std::cout << "Second array after mergesort\n";
  print_array(unsorted2, n2);

  const static int n3 = 3;
  int unsorted3[n3] = {1, 7, -4};

  std::cout << "Third array before mergesort\n";
  print_array(unsorted3, n3);
  
  mergesort(unsorted3, n3);

  std::cout << "Third array after mergesort\n";
  print_array(unsorted3, n3);

  std::vector<double> unsorted4 {6.9, 3.3, -4.9, 2.2, 1.1, 19.3, -14.0, 2.32, 
                                 6.0, 9.2};

  std::cout << "Fourth array before mergesort\n";
  print_array(unsorted4.data(), unsorted4.size());
  
  mergesort(unsorted4.data(), unsorted4.size());

  std::cout << "Fourth array after mergesort\n";
  print_array(unsorted4.data(), unsorted4.size());

  return 0;
}
