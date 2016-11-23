#include "mpi.h"
#include <fstream>

#define MASTER 0

using namespace std;

int main (int argc, char *argv[])
{
  ofstream ostr("data.txt");
  int taskid, numtasks, rc, i, sumid;
  MPI_Status status;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &taskid);
  printf ("MPI task %d has started...\n", taskid);

  rc = MPI_Reduce(&taskid, &sumid, 1, MPI_INT, MPI_SUM, MASTER, MPI_COMM_WORLD);

  if (rc != MPI_SUCCESS) cerr << "Failure on " << taskid << '\n';

  if (taskid == MASTER) {
    ostr << sumid << '\n';
  }

  MPI_Finalize();
  return 0;
}
