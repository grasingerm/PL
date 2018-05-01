#include <mpi.h>
#include <gsl/gsl_rng.h>
#include "gsl-sprng.h"
#include <gsl/gsl_randist.h>

int main(int argc, char *argv[])
{
  int i, k, po; gsl_rng *r;
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &k);
  r = gsl_rng_alloc(gsl_rng_sprng20);

  for (i = 0; i < 10; ++i)
  {
    po = gsl_ran_poisson(r, 2.0);
    printf("Process %d, random number %d: %d\n", k, i+1, po);
  }

  MPI_Finalize();

  return EXIT_SUCCESS;
}
