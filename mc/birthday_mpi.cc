#include "mpi.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <functional>
#include <iomanip>
#include <iostream>
#include <map>
#include <random>
#include <string>
#include <tuple>
#include <vector>

typedef unsigned int uint;
typedef unsigned long ulong;
#define MASTER 0

using namespace std;

tuple<ulong, ulong> birthday_paradox(const uint ptoss, const uint nsides, 
                                   function <int()> flip);

int main(int argc, char* argv[])
{
  ulong n, ptoss, nsides, home_nsuccess, home_ntosses;
  char* rest;
  int taskid, numtasks, rc;
  double psuccess;

  const char* helpstr = "usage: %s [ntries = 10000 [people = 30 [days = 365] ]"
                        " ] \n";

  switch(argc)
  {
    case 1:
      n = 10000;
      ptoss = 30;
      nsides = 365;
      break;
    case 2:
      if (strcmp(argv[1], "--help") == 0)
      {
        printf(helpstr, argv[0]);
        exit(1);
      }
      else
      {
        n = strtoul(argv[2], &rest, 10);
        ptoss = 30;
        nsides = 365;
        break;
      }
    case 3:
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = 365;
      break;
    case 4:
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = strtoul(argv[3], &rest, 10);
      break;
    default:
      printf(helpstr, argv[0]);
      exit(-1);
  }

  random_device rd;
  default_random_engine re (rd ());
  uniform_int_distribution<int> dist (0, nsides-1);
  auto flip = bind (dist, re);

  ulong nsuccess = 0; //!< number of times it takes less than "n" people
  ulong ntosses = 0;  //!< number of tosses total

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &taskid);

  printf("MPI task %d has started ...\n", taskid);

  uint iters_per_task = ceil((double)n / (double)numtasks);
  for (uint i = 0; i < iters_per_task; ++i)
  {
    std::tie (home_ntosses, home_nsuccess) = birthday_paradox(ptoss, nsides, 
                                                              flip);
    printf("%lu, %lu\n", home_ntosses, home_nsuccess);
    
    rc = MPI_Reduce(&home_ntosses, &ntosses, 1, MPI_UNSIGNED_LONG, MPI_SUM, MASTER, MPI_COMM_WORLD);
    if (rc != MPI_SUCCESS)
      printf("%d: failure on mpc_reduce\n", taskid);
    
    rc = MPI_Reduce(&home_nsuccess, &nsuccess, 1, MPI_UNSIGNED_LONG, MPI_SUM, MASTER,
                    MPI_COMM_WORLD);
    if (rc != MPI_SUCCESS)
      printf("%d: failure on mpc_reduce\n", taskid);

    if (taskid == MASTER && false)
    {
      psuccess = (double) nsuccess / (double) (i * numtasks);
      printf("  After %8d attempts, probability of success = %.8f\n",
             i * numtasks, psuccess);
    }
  }

  cout << endl << "----------results----------" << endl;
  cout << "number of days: " << nsides << endl;
  cout << "total iterations: " << n << endl;
  cout << "total people: " << ntosses << endl;
  cout << "avg number of people: " << ntosses / n << endl;
  cout << "max number of people for success: " << ptoss << endl;
  cout << "number of successes: " << nsuccess << endl;
  cout << "probability of success: " << double(nsuccess) / n << endl;

  return 0;
}

// birthday paradox
tuple<ulong, ulong> birthday_paradox(const uint ptoss, const uint nsides, 
                                     function <int()> flip)
{
  ulong ntosses = 1;
  ulong nsuccess = 0;
  vector<bool> bins(nsides, false);
  int day = flip();

  while (!bins[day])
  {
    bins[day] = true;
    day = flip();
    ntosses++;
  }

  if (ntosses <= ptoss)
    nsuccess++;

  printf("args: %d, %d; return: %lu, %lu\n", ptoss, nsides, ntosses, nsuccess);

  return std::tuple<ulong, ulong>(ntosses, nsuccess);
}
