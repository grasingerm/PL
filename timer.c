#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

long diff_micro(struct timespec *start, struct timespec *end)
{
  /* us */
  return ((end->tv_sec * (1000000)) + (end->tv_nsec / 1000)) -
      ((start->tv_sec * 1000000) + (start->tv_nsec / 1000));
}

long diff_milli(struct timespec *start, struct timespec *end)
{
  /* ms */
  return ((end->tv_sec * 1000) + (end->tv_nsec / 1000000)) -
      ((start->tv_sec * 1000) + (start->tv_nsec / 1000000));
}

int main(int argc, char **argv)
{
  unsigned long pause;
  char* ptr;

  switch (argc)
  {
    case 1:
      pause = 10;
      break;
    case 2:
      pause = strtoul (argv [1], &ptr, 10);
      break;
    default:
      printf ("usage: %s [pause_in_seconds]\n", argv [0]);
      exit (1);
  }

  struct timespec start, end;

  clock_gettime(CLOCK_MONOTONIC, &start);

  // Activity to be timed
  sleep(pause);

  clock_gettime(CLOCK_MONOTONIC, &end);

  printf("%ld us\n", diff_micro(&start, &end));
  printf("%ld ms\n", diff_milli(&start, &end));
  printf("\a"); // ring a bell!

  return 0;
}
