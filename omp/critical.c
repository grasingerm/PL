#include <stdlib.h>
#include <stdio.h>
#include <omp.h>

int fib(int n) {
  if (n <= 2) return 1;
  return fib(n - 1) + fib(n - 2);
}

int main (int argc, char* argv[]) {
  int n = 42;
  int i, f;

  double start_time = omp_get_wtime();

#pragma omp parallel for private(f) schedule(dynamic)
  for (i = 1; i <= n; ++i) {
    f = fib(i);
    #pragma omp critical
    {
      printf("fib(%d) = %d\n", i, f);
    }
  }

  double total_time = omp_get_wtime() - start_time;
  printf("Time: %f \n", total_time);

  return 0;
}
