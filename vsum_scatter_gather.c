#include <stdio.h>
#include <stdlib.h>
#include "mpi.h"

#define NELTS 500000
#define MASTER 0
#define MAXPROCS 1024

int main(int argc, char **argv)
{
  double v[NELTS], sum, partial_sums[MAXPROCS], start, end;
  int nprocs, rank, i, count;

  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

  count = NELTS / nprocs;

  if (rank == MASTER)
  {
    start = MPI_Wtime();
    for (i = 0; i < NELTS; ++i)
      v[i] = 1;

    if (count * nprocs != NELTS)
    {
      printf("Number of processes (%d) must divide evenly into problem size "
             "(%d).\n", nprocs, NELTS);
      fflush(stdout);
      MPI_Abort(MPI_COMM_WORLD, 1);
    }
  }

  // distribute vector partitions among processes using MPI_Gather
  MPI_Scatter(v, count, MPI_DOUBLE, v, NELTS, MPI_DOUBLE, MASTER,
              MPI_COMM_WORLD);

  // compute our partial sum
  sum = 0;
  for (i = 0; i < count; ++i)
    sum += v[i];

  MPI_Gather(&sum, 1, MPI_DOUBLE, partial_sums, 1, MPI_DOUBLE, MASTER,
             MPI_COMM_WORLD);

  if (rank == MASTER)
  {
    sum = 0;
    for (i = 0; i < nprocs; ++i)
    {
      printf("partial_sums[%d] = %lf.\n", i, partial_sums[i]);
      sum += partial_sums[i];
    }
    end = MPI_Wtime();
    printf("Vector sum is %lf.\n", sum);
    printf("Total elasped time is %lf.\n", end - start);
  }

  MPI_Finalize();
  return 0;
}
