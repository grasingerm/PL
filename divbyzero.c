#include <stdio.h>
#include <math.h>

int main ()
{
  printf ("3/0 = %lf\n", 3./0.);
  printf ("0/0 = %lf\n", 0./0.);
  printf ("-0/0 = %lf\n", -0./0.);
  printf ("-3/0 = %lf\n", -3./0.);
  printf ("sqrt (-1) = %lf\n", sqrt (-1.));
  printf ("0 - 0/0 = %lf\n", 0 - 0./0.);
  printf ("0/0 - 3 = %lf\n", 0./0. - 3);
  printf ("0/0 * -4 = %lf\n", 0./0. * -4);
  return 0;
}
