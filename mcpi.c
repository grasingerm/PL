#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#define _USE_MATH_DEFINES
#include <math.h>

#ifndef M_PI
#define M_PI ((long double)(3.14159265358979323846264338327950288419716939937510582))
#endif

#define NDEBUG 1

#ifdef NDEBUG
#define debug(M, ...)
#else
#define debug(M, ...) fprintf(stderr, "DEBUG %s:%d: " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#endif

long double mcpi(const unsigned long);

int main(int argc, char const *argv[])
{
  unsigned long n;
  char* rest;
  long double abs_err;

  switch(argc)
  {
    case 1:
      n = 1000000;
      break;
    case 2:
      n = strtoul(argv[1], &rest, 10);
      break;
    default:
      printf("usage: %s [points] ]\n", argv[0]);
      return -1;
  }

  long double pi = mcpi(n);
  abs_err = pi - M_PI;
  printf("pi approximated using %lu points, monte carlo method: %.16Lf\n",
    n, pi);
  printf("actual digits of pi %.16Lf\n", M_PI);
  printf("absolute error: %.16Lf\n", abs_err);
  printf("relative error: %.16Lf\n", abs_err/M_PI);

  return 0;
}

long double mcpi(const unsigned long points)
{
  unsigned long i;
  long double x, y;

  srand (time(NULL));

  unsigned long circle_area = 0;
  unsigned long square_area = 0;

  for (i = 0; i < points; i++)
  {
    x = ((long double) rand() / (long double) RAND_MAX);
    y = ((long double) rand() / (long double) RAND_MAX);

    if (x*x + y*y < 1) circle_area++;
    square_area++;

    debug("x,y = %lf,%lf\n", x, y);
    debug("ca = %lu, sa = %lu\n", circle_area, square_area);
  }

  return 4.0 * circle_area / square_area;
}
