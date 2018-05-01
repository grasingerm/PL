#include <algorithm>
#include <vector>
#include <iostream>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include "ballin_prof.hh"
#include <mpi.h>

static const auto NX        = std::size_t{ 500 };
static const auto left_val  = float{ 1.0 };
static const auto right_val = float{ 10.0 };
static const auto num_steps = unsigned{ 100000 };

void initialize(double uk[], double ukp1[], const std::size_t num_points,
                const std::size_t num_procs, const int my_id) {

  for (auto i = std::size_t{ 1 }; i <= num_points; ++i)
    uk[i] = 0.0;

  if (static_cast<unsigned>(my_id) == 0)             
    uk[1]           = left_val;
  if (static_cast<unsigned>(my_id) == num_procs - 1) 
    uk[num_points]  = right_val;

  std::copy(&uk[1], &uk[num_points], ukp1);
}

void print_values(const double uk[], const unsigned step, const std::size_t
                  num_points, int myid) {
  printf("step %4d: id %2d: ", step, myid);
  for (unsigned i = 0; i < num_points; ++i)
    printf("%4.2lf ", uk[i]);
  putc('\n', stdout);
}

using namespace std;

int main(int argc, char *argv[]) {
  double *uk, *ukp1, *temp;

  const double dx = 1.0/NX;
  const double dt = 0.5 * dx * dx;

  int num_procs, myid, num_points;
  MPI_Status status;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &num_procs);
  MPI_Comm_rank(MPI_COMM_WORLD, &myid);

  auto lnbr   = myid - 1;
  auto rnbr   = myid + 1;
  num_points  = floor(NX / num_procs);
  if (myid == 0) num_points += NX % num_procs;

  printf("id = %d, n = %d\n", myid, num_points); 

  //uk    = (double *) malloc(sizeof(double) * (num_points + 2));
  //ukp1  = (double *) malloc(sizeof(double) * (num_points + 2));
  vector<double> vuk(num_points + 2), vukp1(num_points + 2);
  uk      = vuk.data();
  ukp1    = vukp1.data();

  initialize(uk, ukp1, num_points, num_procs, myid);

  MPI_Request req_recvl, req_recvr, req_sendl, req_sendr;

  if (myid == 0) tic();
  for (unsigned k = 0; k < num_steps; ++k) {
    //if (myid == 0) cout << "Step: " << k << "\n=============================\n";


    if (myid != 0) {
      MPI_Isend(&uk[1], 1, MPI_DOUBLE, lnbr, 1, MPI_COMM_WORLD, &req_sendl);
      MPI_Irecv(&uk[0], 1, MPI_DOUBLE, lnbr, 2, MPI_COMM_WORLD, &req_recvl);
    }

    if (myid != num_procs-1) {
      MPI_Isend(&uk[num_points], 1, MPI_DOUBLE, rnbr, 2, MPI_COMM_WORLD,
                &req_sendr);
      MPI_Irecv(&uk[num_points+1], 1, MPI_DOUBLE, rnbr, 1, MPI_COMM_WORLD, 
                &req_recvr);
    }

    for (int i = 2; i < num_points; ++i)
      ukp1[i] = uk[i] + (dt/(dx*dx))*(uk[i-1] - 2*uk[i] + uk[i+1]);

    if (myid != 0) { 
      MPI_Wait(&req_sendl, &status);
      MPI_Wait(&req_recvl, &status);

      const unsigned i = 1;
      ukp1[i] = uk[i] + (dt/(dx*dx))*(uk[i-1] - 2*uk[i] + uk[i+1]);
    }

    if (myid != num_procs-1) { 
      MPI_Wait(&req_sendr, &status);
      MPI_Wait(&req_recvr, &status);

      const unsigned i = num_points;
      ukp1[i] = uk[i] + (dt/(dx*dx))*(uk[i-1] - 2*uk[i] + uk[i+1]);
    }

    temp  =   ukp1;
    ukp1  =   uk;
    uk    =   temp;
  }
  if (myid == 0) toc();

  print_values(uk, num_steps, num_points, myid);

  cout << MPI_Finalize() << '\n';

  return 0;
}
