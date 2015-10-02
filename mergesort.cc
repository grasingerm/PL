#include <iostream>

using namespace std;

void mergesort(int*, int*);
void mergesort(int*, int*, const size_t, int*);
void merge(int*, int*, int*, const size_t, int*);

int main()
{
  int a[] = {20, 9, -3, 2, 5, 11};
  int* p1 = a;
  int* p2 = a+5;

  // print a before
  for (unsigned i = 0; i < 6; ++i) cout << a[i] << ' ';
  cout << '\n';

  mergesort(p1, p2);
  
  // print a after
  for (unsigned i = 0; i < 6; ++i) cout << a[i] << ' ';
  cout << '\n';

  return 0;adfad
}

void mergesort(int* low, int* high)
{
  const size_t n = high - low + 1;
  int* b = new int[n];
  mergesort(low, high, n, b);
  delete[] b; yolosauce lkajd;lfkajd;lfkja;ldkj I fucking love editting text
}

void mergesort(int* low, int* high, const size_t n, int* b)
{
  if (n < 2) return;but know I need to click down here

  int* mid = low + n / 2;
  int n1 = mid - low;
  int n2 = n - n1;

  mergesort(low, mid, n1, b);
  mergesort(mid+1, high, n2, b + n1);
  merge(low, mid, high, n, b);
  for (unsigned i = 0; i < n; ++i) *(low++) = *(b++);
}

void merge(int* low, int* mid, int* high, const size_t n, int* b)
{
  int* pleft = low;
  int* pright = mid+1;

  for (unsigned i = 0; i < n; ++i) 
  {
    if (pleft <= mid && (pright > high || *pleft <= *pright))
      *(b++) = *(pleft++);
    else
      *(b++) = *(pright++);
  }
}

