#include "stdio.h"
#include <stdlib.h>

#include <mpi.h>

int main(int argc, char *argv[])
{
  int tid, nthreads;
  char *cpu_name;
  double time_initial, time_current, time;

  MPI_Init(&argc, &argv);
  time_initial = MPI_Wtime();

  MPI_Comm_rank(MPI_COMM_WORLD, &tid);
  MPI_Comm_size(MPI_COMM_WORLD, &nthreads);

  cpu_name = (char *)calloc(80, sizeof(char));
  gethostname(cpu_name, 80);
  time_current = MPI_Wtime();
  time = time_current - time_initial;
  printf("%.3f tid=%i : hello MPI user: machine=%s [NCPU=%i]\n", time,
         tid, cpu_name, nthreads);
  MPI_Finalize();
  return(0);
}
