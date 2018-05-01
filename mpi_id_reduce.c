#include "mpi.h"
#include <stdio.h>
#include <stdlib.h>

#define MASTER 0

int main (int argc, char *argv[])
{
  int taskid, numtasks, rc, i, sumid;
  MPI_Status status;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &taskid);
  printf ("MPI task %d has started...\n", taskid);

  rc = MPI_Reduce(&taskid, &sumid, 1, MPI_INT, MPI_SUM, MASTER, MPI_COMM_WORLD);

  if (rc != MPI_SUCCESS) printf("%d: failure on mpc_reduce\n", taskid);

  if (taskid == MASTER) {
    printf("Sum of ids = %d\n", sumid);
  }

  MPI_Finalize();
  return 0;
}
