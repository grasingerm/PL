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

      assert( (x == y      ||    x != y)              && 
              (x > y       ||    x <= y)              &&
              (x >= y      ||    x < y)               &&
              (x           ||    !x)                  &&
              (y           ||    !y)                  &&
              (x % 2 == 0  ||    x % 2 != 0)          &&
              (y % 2 == 0  ||    y % 2 != 0));
      printf("%11d == %11d || %11d != %11d; i = %18llu\n", x, y, x, y, i); 
   }
   
   return(0);
}
