#include <cmath>
#include <iostream>

template <typename T> void merge(const T* fst, const unsigned n1, const T* snd, 
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

template <typename T> void mergesort(const T* to_sort, T* sorted, 
                                     const unsigned n) {
  if (n == 1) {
    sorted[0] = to_sort[0];
    return;
  }
  else if (n == 2)
  {
    if (to_sort[0] < to_sort[1]) {
      sorted[0] = to_sort[0];
      sorted[1] = to_sort[1];
    }
    else {
      sorted[0] = to_sort[1];
      sorted[1] = to_sort[0];
    }
  }
  else {
    const unsigned mid = n / 2;
    mergesort(to_sort, sorted, mid);
    mergesort(to_sort+mid, sorted+mid, n-mid);
    merge(to_sort, mid, to_sort+mid, n-mid, sorted);
  }
}

template <typename T> void print_array(const T* arr, const unsigned n) {
  for (unsigned i = 0; i < n-1; ++i) std::cout << arr[i] << ", ";
  std::cout << arr[n-1] << '\n';
}

int main() {
  const static int n1 = 2;
  int unsorted1[n1] = {5, 1};
  int sorted1[n1] = {0};

  std::cout << "First pair of arrays before mergesort\n";
  print_array(unsorted1, n1);
  print_array(sorted1, n1);
  
  mergesort(unsorted1, sorted1, n1);

  std::cout << "First pair of arrays after mergesort\n";
  print_array(unsorted1, n1);
  print_array(sorted1, n1);

  const static int n2 = 6;
  int unsorted2[n2] = {3, 5, 1, 7, -4, 4};
  int sorted2[n2] = {0};

  std::cout << "Second pair of arrays before mergesort\n";
  print_array(unsorted2, n2);
  print_array(sorted2, n2);
  
  mergesort(unsorted2, sorted2, n2);

  std::cout << "Second pair of arrays after mergesort\n";
  print_array(unsorted2, n2);
  print_array(sorted2, n2);

  const static int n3 = 3;
  int unsorted3[n3] = {1, 7, -4};
  int sorted3[n3] = {0};

  std::cout << "Third pair of arrays before mergesort\n";
  print_array(unsorted3, n3);
  print_array(sorted3, n3);
  
  mergesort(unsorted3, sorted3, n3);

  std::cout << "Third pair of arrays after mergesort\n";
  print_array(unsorted3, n3);
  print_array(sorted3, n3);

  return 0;
}
