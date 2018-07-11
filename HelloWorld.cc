#include <mpi.h>
#include <iostream>


int main(int argc, char *argv[])
{

  //
  // Initialize MPI
  //
  int requested, provided, claimed;
  requested = MPI_THREAD_MULTIPLE;
  MPI_Init_thread(&argc, &argv,requested,&provided);

  MPI_Query_thread(&claimed);

  std::cout << "MPI_Init requested: " << requested << ", recieved: " << provided 
	    << ", and claimed: " << claimed << std::endl;

  MPI_Status status;
  MPI_Comm comm = MPI_COMM_WORLD;

  //
  // get number cores and core ID
  //
  int size, id; 
  MPI_Comm_rank(comm, &id);
  MPI_Comm_size(comm, &size);
  
  std::cout << "Hello World from " << id << "/" << size << std::endl;


  MPI_Barrier(MPI_COMM_WORLD);

  MPI_Finalize();

  std::cout << "FINISHED" << std::endl;

  //
  //
  //
  return 0;
}
