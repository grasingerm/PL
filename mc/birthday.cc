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
  unsigned long n, ptoss, nsides;
  char* rest;
  unsigned int binsize = 10;
  unsigned int nstars = 100;

  switch(argc)
  {
    case 1:
      n = 10000;
      ptoss = 30;
      nsides = 365;
      break;
    case 2:
      n = strtoul(argv[1], &rest, 10);
      ptoss = 30;
      nsides = 365;
      break;
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
    case 5:
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = strtoul(argv[3], &rest, 10);
      binsize = strtoul(argv[4], &rest, 10);
      break;
    case 6:
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = strtoul(argv[3], &rest, 10);
      binsize = strtoul(argv[4], &rest, 10);
      nstars = strtoul(argv[5], &rest, 10);
      break;
    default:
      printf("usage: %s [ntries [people [days [binsize [nstars] ] ] ] ]\n",
          argv[0]);
      return -1;
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

  cout << "starting simulation ..." << endl;

  for (unsigned int i = 0; i < n; ++i)
  {
    if ((i+1) % update == 0) 
      cout << setw(10) << i+1 << '/' << n << ' ' 
        << setw(4) << double(i+1) / n * 100 << '%' << endl;

    unsigned int ntosses = 1;
    int day = flip();

    while (!bins[day])
    {
      bins[day] = true;
      day = flip();
      ntosses++;
    }

    if (ntosses <= ptoss)
      nsuccess++;

    ++cbins[(ntosses/binsize) * binsize];
    nppl_total += ntosses;
    bins.insert(bins.begin(), nsides, false);
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

