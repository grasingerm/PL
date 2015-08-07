#include <stdio.h>
#include <stdbool.h>

int main(int argc, char const *argv[])
{
  puts ("Can we do arithmetic with 'booleans'?");
  printf ("true + 1 = %d\n", true+1);
  printf ("false + 1 = %d\n", false+1);
  printf ("true + false = %d\n", true+false);
  printf ("true - 1 = %d\n", true-1);
  printf ("false - 1 = %d\n", false-1);
  printf ("true - false = %d\n", true-false);
  printf ("true * -1 = %d\n", true*-1);
  printf ("false * -1 = %d\n", false*-1);
  printf ("true * false = %d\n", true*false);
  printf ("true + true * -1 = %d\n", true+true*-1);
  printf ("true - 1 == false ? = %d\n", true-1 == false);

  return 0;
}
