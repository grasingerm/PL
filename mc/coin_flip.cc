#include <random>
#include <iostream>
#include <functional>

using namespace std;

int main(int argc, char* argv[])
{
  unsigned long n, ptoss, nsides;
  char* rest;

  switch(argc)
  {
    case 1:
      n = 10000;
      ptoss = 4;
      nsides = 2;
      break;
    case 2:
      n = strtoul(argv[1], &rest, 10);
      ptoss = 4;
      nsides = 2;
      break;
    case 3:
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = 2;
      break;
    case 4:
      n = strtoul(argv[1], &rest, 10);
      ptoss = strtoul(argv[2], &rest, 10);
      nsides = strtoul(argv[3], &rest, 10);
      break;
    default:
      printf("usage: %s [ntries [ptosses [nsides] ] ]\n", argv[0]);
      return -1;
  }

  random_device rd;

  default_random_engine re (rd ());
  uniform_int_distribution<int> dist (0, nsides-1);
  auto flip = bind (dist, re);

  unsigned int ntosses_total = 0;
  unsigned int nsuccess = 0; //!< number of times it takes more than "n" tosses

  cout << "starting simulation ..." << endl;

  for (unsigned int i = 0; i < n; ++i)
  {
    // cout << "----------" << i+1 << "----------" << endl;

    unsigned int ntosses = 2; 
    int prevtoss = flip ();
    int currtoss = flip ();

    // cout << prevtoss << ", " << currtoss << endl;

    while (prevtoss != currtoss)
    {
      ntosses++;
      prevtoss = currtoss;
      currtoss = flip ();

      // cout << prevtoss << ", " << currtoss << endl;
    }

    if (ntosses >= ptoss)
      nsuccess++;
   
    ntosses_total += ntosses;
  }

  cout << endl << "----------results----------" << endl;
  cout << "number of sides: " << nsides << endl;
  cout << "total iterations: " << n << endl;
  cout << "total tosses: " << ntosses_total << endl;
  cout << "avg number of tosses: " << double(ntosses_total) / n << endl;
  cout << "number of tosses for success: " << ptoss << endl; 
  cout << "number of successes: " << nsuccess << endl;
  cout << "probability of success: " << double(nsuccess) / n << endl;

  return 0;
}

