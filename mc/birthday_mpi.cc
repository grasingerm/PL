#include "mpi.h"
#include <random>
#include <iostream>
#include <functional>
#include <vector>
#include <map>
#include <iomanip>
#include <string>

using namespace std;

int main(int argc, char* argv[])
{
  unsigned int procs;
  unsigned long n, ptoss, nsides;
  char* rest;
  unsigned int binsize = 10;
  unsigned int nstars = 100;
  int taskid, numtasks, rc, i;

  switch(argc)
  {
    case 2:
      procs = strtoul(argv[1], &rest, 10);
      n = 10000;
      ptoss = 30;
      nsides = 365;
      break;
    case 3:
      procs = strtoul(argv[1], &rest, 10);
      n = strtoul(argv[2], &rest, 10);
      ptoss = 30;
      nsides = 365;
      break;
    case 4:
      procs = strtoul(argv[1], &rest, 10);
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = 365;
      break;
    case 5:
      procs = strtoul(argv[1], &rest, 10);
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = strtoul(argv[3], &rest, 10);
      break;
    case 6:
      procs = strtoul(argv[1], &rest, 10);
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = strtoul(argv[3], &rest, 10);
      binsize = strtoul(argv[4], &rest, 10);
      break;
    case 7:
      procs = strtoul(argv[1], &rest, 10);
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = strtoul(argv[3], &rest, 10);
      binsize = strtoul(argv[4], &rest, 10);
      nstars = strtoul(argv[5], &rest, 10);
      break;
    default:
      printf("usage: %s procs [ntries [people [days [binsize [nstars] ] ] ] ]\n",
          argv[0]);
      exit(-1);
  }

  int update = n / 20;

  random_device rd;

  default_random_engine re (rd ());
  uniform_int_distribution<int> dist (0, nsides-1);
  auto flip = bind (dist, re);

  unsigned int nppl_total = 0;
  unsigned int nsuccess = 0; //!< number of times it takes less than "n" people
  vector<bool> bins(nsides,false);
  map<unsigned int, unsigned int> cbins;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &taskid);

  printf("MPI task %d has started ...\n", taskid);

  for (unsigned int i = 0; i < n; ++i)
  {
    if ((i+1) % update == 0) 
      cout << setw(10) << i+1 << '/' << n << ' ' 
        << setw(4) << double(i+1) / n * 100 << '%' << endl;

    unsigned int ntosses = 1;
    int day = flip();

    // cout << day << endl;

    while (!bins[day])
    {
      bins[day] = true;
      day = flip();
      ntosses++;

      // cout << day << endl;
    }

    if (ntosses <= ptoss)
      nsuccess++;

    ++cbins[(ntosses/binsize) * binsize];
    nppl_total += ntosses;
    bins.insert(bins.begin(), nsides, false);

    rc = MPI_Reduce(&homepi, &pisum, 1, MPI_DOUBLE, MPI_SUM, MASTER,
                    MPI_COMM_WORLD);
    if (rc != MPI_SUCCESS)
      printf("%d: failure on mpc_reduce\n", taskid);

    if (taskid == MASTER)
    {
      pi = pisum / numtasks;
      avepi = ((avepi * i) + pi)/(i + 1);
      printf("  After %8d throws, average value of pi = %10.8f\n",
             (DARTS * (i + 1)), avepi);
    }
  }

  cout << endl << "----------results----------" << endl;
  cout << "number of days: " << nsides << endl;
  cout << "total iterations: " << n << endl;
  cout << "total people: " << nppl_total << endl;
  cout << "avg number of people: " << double(nppl_total) / n << endl;
  cout << "max number of people for success: " << ptoss << endl;
  cout << "number of successes: " << nsuccess << endl;
  cout << "probability of success: " << double(nsuccess) / n << endl;

  cout << endl << "-----histogram-----" << endl;
  for (const auto& c : cbins)
    cout << fixed << setprecision(1) << setw(4)
         << c.first << ' ' << string(c.second * nstars / n, '*') << '/'
         << endl;
  cout << endl << "* = " << n / nstars << endl << endl;

  return 0;
}

