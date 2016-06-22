#include <stdio.h>
#include <stdlib.h>

int main()
{
  double* large_arr = (double *)malloc(sizeof(double) * 1000);
  if (large_arr)
  {
    printf("It allocated!\n");
    free(large_arr); /* we don't want memory leaks!! */
  }
  else
    printf("That amount of memory doesn't exist silly\n");

  return 0;
}
