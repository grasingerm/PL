#include <stdlib.h>
#include <stdio.h>
#include <omp.h>

int main (int argc, char* argv[]) {
  int n = 500000;
  int not_primes = 0;

  double start_time = omp_get_wtime();

#pragma omp parallel for reduction(+:not_primes) schedule(dynamic)
  for (int i = 2; i <= n; ++i) {
    for (int j = 2; j < i; ++j) {
      int modij = i % j;
      if (modij == 0) {
        not_primes++;
        break;
      }
    }
  }

  double total_time = omp_get_wtime() - start_time;
  printf("Primes: %d  Time: %f \n", n - not_primes, total_time);

  return 0;
}
