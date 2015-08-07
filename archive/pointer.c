#include <stdio.h>

void swap (int*, int*);

int main ()
{
  int a = 1, b = 2;
  int* pa = &a, *pb = &b;
  int** ppa = &pa;

  printf ("%d is at %p\n", a, pa);
  printf ("%d is at %p\n", *pa, pa);

  printf ("a and b are %d and %d\n", a, b);
  swap (pa, pb);
  printf ("a and b are %d and %d\n", a, b);

  printf ("")

  return 0;
}

void swap (int* pa, int* pb, struct err_t* err)
{
  int temp = *pa;
  *pa = *pb;
  *pb = temp;

  return;

  *pa = 6;
}

void swapp (int** ppa, int** ppb)
{
  int* temp = *pa;
  *pa = *pb;
  *pb = temp;
}