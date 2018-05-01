#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

int main(int argc, char* argv[])
{
  MPI_Init(&argc, &argv);

  int ntasks, taskid, rc;
  MPI_Comm_size(MPI_COMM_WORLD, &ntasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &taskid);
  printf("MPI task %d has started..\n", taskid);

  MPI_Status status;
  int idcopy = taskid;
  printf("MPI task %d: idcopy = %d\n", taskid, idcopy);

  if (taskid == 0)
  {
    printf("Sending message from %d to %d\n", 0, 1);
    rc = MPI_Send(&taskid, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
    if (rc == MPI_SUCCESS) printf("Message sent.\n");
    else { fprintf(stderr, "Send failed.\n"); exit(-1); }
  }

  if (taskid == 1)
  {
    printf("Recieving message...\n");
    rc = MPI_Recv(&idcopy, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
    if (rc == MPI_SUCCESS) printf("Message recieve executed properly.\n");
    else { fprintf(stderr, "Recieve failed.\n"); exit(-1); }
  }

  printf("MPI task %d: idcopy = %d\n", taskid, idcopy);

  MPI_Finalize();
  return 0;
}
