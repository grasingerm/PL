#include <mpi.h>
#include <stdio.h>
#include <time.h>

int main(int argc, char *argv[])
{
  int large_arr[1000*1000] = {0}; 
  int npes, myrank;

  clock_t start = clock(), diff;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &npes);

  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
  printf("From process %d out of %d, Hello world!\n", myrank, npes);
  int begin = (1000*1000*myrank) / npes;
  int end = (1000*1000*(myrank+1))/ npes;
  int i;
  for (i = begin; i < end; ++i) large_arr[i] = 42;
  MPI_Finalize();
  diff = clock() - start;

  int msec = diff * 1000 / CLOCKS_PER_SEC;
  printf("Time taken %d seconds %d miliseconds\n", msec/1000, msec%1000);

  return 0;
}
