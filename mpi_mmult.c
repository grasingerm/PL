#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mpi.h"

#define NRA 62  /* number of rows in matrix A */
#define NCA 15  /* number of cols in matrix A */
#define NCB 7   /* number of cols in matrix B */
#define MASTER 0

enum { FROM_MASTER, FROM_WORKER };

MPI_Status status;

int main(int argc, char **argv)
{
  int nprocs, procid, nworkers, rows, avg_row, extra,
      offset, i, j, k, seed;
  char *rest;

  double a[NRA][NCA], b[NCA][NCB], c[NRA][NCB];

  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &procid);
  MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  nworkers = nprocs - 1;

  if (procid == MASTER)
  {
    if (argc == 1)
    {
      seed = strtol(argv[1], &rest, 10);
      srand(seed);
    }

    // init matrices
    for (i = 0; i < NRA; ++i)
      for (j = 0; j < NCA; ++j)
        a[i][j] = rand() % (1 + i + j);

    for (i = 0; i < NCA; ++i)
      for (j = 0; j < NCB; ++j)
        b[i][j] = rand() % (1 + i * j);

    // send matrix data to the worker processes
    avg_row = NRA / nworkers;
    extra = NRA % nworkers;
    offset = 0;

    // send data to workers
    for (i = 1; i <= nworkers; ++i)
    {
      rows = (i <= extra) ? avg_row + 1 : avg_row;
      MPI_Send(&offset, 1, MPI_INT, i, FROM_MASTER, MPI_COMM_WORLD);
      MPI_Send(&rows, 1, MPI_INT, i, FROM_MASTER, MPI_COMM_WORLD);
      MPI_Send(&a[offset][0], rows * NCA, MPI_DOUBLE, i, FROM_MASTER,
               MPI_COMM_WORLD);
      MPI_Send(&b, NCA * NCB, MPI_DOUBLE, i, FROM_MASTER, MPI_COMM_WORLD);
      offset = offset + rows;
    }

    // wait for results from all workers
    for (i = 1; i <= nworkers; ++i)
    {
      MPI_Recv(&offset, 1, MPI_INT, i, FROM_WORKER, MPI_COMM_WORLD, &status);
      MPI_Recv(&rows, 1, MPI_INT, i, FROM_WORKER, MPI_COMM_WORLD, &status);
      MPI_Recv(&c[offset][0], rows * NCB, MPI_DOUBLE, i, FROM_WORKER, MPI_COMM_WORLD,
               &status);
    }
    printf("element c[0,0] is %lf.\n", c[0][0]);
  }

  if (procid > MASTER)
  {
    MPI_Recv(&offset, 1, MPI_INT, MASTER, FROM_MASTER, MPI_COMM_WORLD, &status);
    MPI_Recv(&rows, 1, MPI_INT, MASTER, FROM_MASTER, MPI_COMM_WORLD, &status);
    MPI_Recv(&a, rows * NCA, MPI_DOUBLE, MASTER, FROM_MASTER, MPI_COMM_WORLD,
             &status);
    MPI_Recv(&b, NCA * NCB, MPI_DOUBLE, MASTER, FROM_MASTER, MPI_COMM_WORLD,
             &status);

    // compute our part
    for (k = 0; k < NCB; ++k)
      for (i = 0; i < rows; ++i)
      {
        c[i][j] = 0.0;
        for (j = 0; j < NCA; ++j)
          c[i][k] += a[i][j] * b[j][k];
      }
    MPI_Send(&offset, 1, MPI_INT, MASTER, FROM_WORKER, MPI_COMM_WORLD);
    MPI_Send(&rows, 1, MPI_INT, MASTER, FROM_WORKER, MPI_COMM_WORLD);
    MPI_Send(&c, rows * NCB, MPI_DOUBLE, MASTER, FROM_WORKER, MPI_COMM_WORLD);
  } // end of worker

  MPI_Finalize();
  return 0;
}
