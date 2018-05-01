#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>

double time_diff(struct timeval* x, struct timeval* y)
{
    double x_ms , y_ms , diff;
     
    x_ms = (double)x->tv_sec*1000000 + (double)x->tv_usec;
    y_ms = (double)y->tv_sec*1000000 + (double)y->tv_usec;
     
    diff = (double)y_ms - (double)x_ms;
     
    return diff;
}

void add_42_ijlin(double* arr, const unsigned int n_rows, const unsigned int n_cols)
{
  unsigned int i, j;

  for (j = 0; j < n_rows; j++)
    for (i = 0; i < n_cols; i++)
      arr[j*n_cols + i] += 42;
}

void add_42_ijbad(double* arr, const unsigned int n_rows, const unsigned int n_cols)
{
  unsigned int i, j;

  for (i = 0; i < n_cols; i++)
    for (j = 0; j < n_rows; j++)
      arr[j*n_cols + i] += 42;
}

void add_42_jilin(double* arr, const unsigned int n_rows, const unsigned int n_cols)
{
  unsigned int i, j;

  for (j = 0; j < n_cols; j++)
    for (i = 0; i < n_rows; i++)
      arr[j*n_rows + i] += 42;
}

void add_42_jibad(double* arr, const unsigned int n_rows, const unsigned int n_cols)
{
  unsigned int i, j;

  for (i = 0; i < n_rows; i++)
    for (j = 0; j < n_cols; j++)
      arr[j*n_rows + i] += 42;
}

#define PROFILE(description, block) \
  do  \
  {   \
    struct timeval start, end; \
    \
    gettimeofday(&start, NULL); \
    \
    do block while (0); \
    \
    gettimeofday(&end, NULL); \
    \
    fputs(description, stdout); \
    printf("%.6lf seconds\n", time_diff(&start, &end) / 1e6); \
  } while (0);

int main (int argc, char* argv[])
{
  unsigned long n, m;
  char* rest;

  switch(argc)
  {
    case 1:
      n = 10000;
      m = n;
      break;
    case 2:
      n = strtoul(argv[1], &rest, 10);
      m = n;
      break;
    case 3:
      n = strtoul(argv[1], &rest, 10);
      m = strtoul(argv[2], &rest, 10);
      break;
    default:
      printf("usage: %s [n_rows [n_cols] ]\n", argv[0]);
      return -1;
  }

  double *a = (double*) calloc (n*m, sizeof(double));
  if (a == NULL)
  {
    fputs ("ALLOCATION FAILED\n", stderr);
    return -1;
  }

  printf("Profiling operations on %lu by %lu array\n", n, m);
  PROFILE("function add_42_ijlin: ", { add_42_ijlin(a, n, m); });
  PROFILE("function add_42_ijbad: ", { add_42_ijbad(a, n, m); });
  PROFILE("function add_42_jilin: ", { add_42_jilin(a, n, m); });
  PROFILE("function add_42_jibad: ", { add_42_jibad(a, n, m); });

  return 0;
}
