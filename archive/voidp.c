#include <stdio.h>

int main ()
{
  int d = 5;
  void* vp = &d;

  printf ("%d at %p\n", *(int *)vp, vp);

  return 0;
}
