#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <sys/time.h>

int main() {
  int i;
  double A[2000000], B[1000000], C[1000000];
  struct timeval start_time, stop_time, elapsed_time;  // timers
  gettimeofday(&start_time, NULL); // Unix timer

  #pragma acc kernels
  for (i = 0; i < 1000000; ++i) {
    A[i] = 4 * i;
    B[i] = B[i] + 2;
    C[i] = A[i] + 2 * B[i];
  }

  gettimeofday(&stop_time, NULL);
  timersub(&stop_time, &start_time, &elapsed_time); // Unix time subtract routine
  printf("Total time was %f seconds.\n", elapsed_time.tv_sec+elapsed_time.tv_usec/1000000.0);

  return 0;
}
