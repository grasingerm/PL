#include <random>
#include <iostream>
#include <functional>
#include <vector>

using namespace std;

int main(int argc, char* argv[])
{
  unsigned long n, ptoss, nsides;
  char* rest;

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
    default:
      printf("usage: %s [ntries [people [days] ] ]\n", argv[0]);
      return -1;
  }

  random_device rd;

  default_random_engine re (rd ());
  uniform_int_distribution<int> dist (0, nsides-1);
  auto flip = bind (dist, re);

  unsigned int nppl_total = 0;
  unsigned int nsuccess = 0; //!< number of times it takes less than "n" people
  vector<bool> bins(nsides,false);

  cout << "starting simulation ..." << endl;

  for (unsigned int i = 0; i < n; ++i)
  {
    cout << "----------" << i+1 << "----------" << endl;

    unsigned int ntosses = 0;
    int day = flip();

    cout << day << endl;

    while (!bins[day])
    {
      ntosses++;
      bins[day] = true;
      day = flip();

      cout << day << endl;
    }

    if (ntosses <= ptoss)
      nsuccess++;

    nppl_total += ntosses;
    bins.insert(bins.begin(), false);
  }

  cout << endl << "----------results----------" << endl;
  cout << "number of days: " << nsides << endl;
  cout << "total iterations: " << n << endl;
  cout << "total people: " << nppl_total << endl;
  cout << "avg number of people: " << double(nppl_total) / n << endl;
  cout << "max number of people for success: " << ptoss << endl;
  cout << "number of successes: " << nsuccess << endl;
  cout << "probability of success: " << double(nsuccess) / n << endl;

  return 0;
}

