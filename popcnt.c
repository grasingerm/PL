#include <stdio.h>
#include <cfortran.h>

fortran int POPCNT();

int main ()
{
  unsigned int u = 7;
  printf ("%d 1-bits in %u\n", POPCNT (u), u);

  return 0;
}
