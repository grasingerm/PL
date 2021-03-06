#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
   unsigned long long i = 0;
   time_t t;

   srand((unsigned) time(&t));

   while (++i)
   {
      int x, y;

      x = rand();
      y = rand();

      printf("%11d == %11d || %11d != %11d; i = %llu\n", x, y, x, y, i);
      assert( (x == y      ||    x != y)              && 
              (x > y       ||    x <= y)              &&
              (x >= y      ||    x < y)               &&
              (x           ||    !x)                  &&
              (y           ||    !y)                  &&
              (x % 2 == 0  ||    x % 2 != 0)          &&
              (y % 2 == 0  ||    y % 2 != 0)); 
   }
   
   return(0);
}
