#include <math.h>
#include <mpi.h>
#include <gsl/gsl_rng.h>
#include "gsl-sprng.h"

int main(int argc, char *argv[])
{
  int i, k, N;
  double u, ksum, Nsum;
  gsl_rng *r;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &N);
  MPI_Comm_rank(MPI_COMM_WORLD, &k);

  r = gsl_rng_alloc(gsl_rng_sprng20);
  for (i = 0; i < 10000; ++i)
  {
    u = gsl_rng_uniform(r);
    ksum += exp(-u*u);
  }

  MPI_Reduce(&ksum, &Nsum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

  if (k == 0)
    printf("Monte carlo estimate is %f\n", (Nsum/10000)/N);

  MPI_Finalize();

  return EXIT_SUCCESS;
}
