#include <cstdio>
#include <cstdlib>
#include "ballin_prof.hh"

#define NX 200
#define LEFTVAL 1.0
#define RIGHTVAL 10.0
#define NSTEPS 10000

#define CHECKP(p, msg) \
  do { \
    if(p == NULL) { \
      fprintf(stderr, msg); \
      exit(-1); \
    } \
  } while(0)

void initialize(double* uk, double* ukp1) {
  uk[0] = LEFTVAL;
  uk[NX-1] = RIGHTVAL;
  for (unsigned i = 1; i < NX-1; ++i)
    uk[i] = 0.0;
  for (unsigned i = 0; i < NX; ++i)
    ukp1[i] = uk[i];
}

int main(int argc, char* argv[]) {
  double *uk = (double *) malloc(sizeof(double) * NX);
  double *ukp1 = (double *) malloc(sizeof(double) * NX);
  CHECKP(uk, "malloc failed for 'uk'.\n");
  CHECKP(ukp1, "malloc failed for 'ukp1'.\n");
  double *temp;

  const double dx = 1.0/NX;
  const double dt = 0.5 * dx * dx;

  initialize(uk, ukp1);

  tic();
  for (int k = 0; k < NSTEPS; ++k) {
    #pragma omp parallel for schedule(static)
    for (unsigned i = 1; i < NX-1; ++i)
      ukp1[i] = uk[i] + (dt/(dx*dx))*(uk[i+1] - 2*uk[i] + uk[i-1]);

    temp = ukp1;
    ukp1 = uk;
    uk = temp;
  }

  toc();
  for (unsigned i = 0; i < NX; ++i)
    printf("%4.2lf ", uk[i]);
  putc('\n', stdout);
  fflush(stdout);

  return 0;
}
