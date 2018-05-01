#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#define SIMPLE_SPRNG
#define USE_MPI
#include "sprng.h"

int main(int argc, char *argv[])
{
  double rn; int i, k;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &k);
  init_sprng(DEFAULT_RNG_TYPE, 0, SPRNG_DEFAULT);
  for (i = 0; i < 10; ++i)
  {
    rn = sprng();
    printf("Process %d, random number %d: %f\n", k, i+1, rn);
  }
  MPI_Finalize();
  
  return EXIT_SUCCESS;
}
