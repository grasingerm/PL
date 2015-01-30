#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define D 1
#define Q 3

int main(int argc, char* argv[])
{
  unsigned int i;
  int k;

  unsigned int n;
  unsigned int n_iters;
  double kappa;

  switch (argc)
  {
    case 1:
      n = 20;
      n_iters = 100;
      kappa = 0.1;
      break;
    case 2:
      n = strtoul(argv[1], NULL, 10);
      n_iters = 100;
      kappa = 0.1;
      break;
    case 3:
      n = strtoul(argv[1], NULL, 10);
      n_iters = strtoul(argv[2], NULL, 10);
      kappa = 0.1;
      break;
    case 4:
      n = strtoul(argv[1], NULL, 10);
      n_iters = strtoul(argv[2], NULL, 10);
      kappa = 0.1;
      break;
    default:
      fprintf(stderr, "usage: %s [[[n=20] n_iters=100] kappa=0.1]\n", argv[0]);
      exit(1);
  }

  int dof = n*D*Q;
  double* f = (double*) calloc(dof, double);
  double* phi = (double*) calloc(n, double);

  const double delta_x = 1.0;
  const double delta_t = 1.0;
  const double c_u = delta_x / delta_t;
  const double w[] = { 4./6., 1./6., 1./6. };
  const double c[] = { 0., -c_u, c_u };
  const double c_s = 1. / sqrt(3);

  double tau = (D*kappa / c_u*delta_x) + 0.5;
  double omega = delta_t / tau;

  for (i = 1; i <= n_iters; ++i)
  {
    stream(f, n);
    collide(f, phi, n);
    enforce_bcs(f, n);
    map_to_macro(f, phi, n);
  }

  write_to_gnuplot(phi, n);

  return 0;
}

// stream particles
void stream(double* f, const unsigned int n)
{
  int k;

  for (k = 1; k < n; ++k) f[n + k-1] = f[n + k];
  for (k = n-1; k > 0; --k) f[2*n + k] = f[2*n + k-1];
}

// collision step
void collide(double* f, const double* phi, const unsigned int n, 
  const unsigned int omega)
{
  int k, d;
  double f_eq;

  for (k = 0; k < n; ++k)
    for (d = 0; d < D; ++d)
    {
      f_eq = phi[k] * w[d];
      f[n*d + k] = (1-omega)*f[n*d + k] + omega*f_eq;
    }
}

void enforce_bcs(double* phi, )

// map particle distrubtions to macroscopic variables
void map_to_macro(const double* f, double* phi, const unsigned int n)
{
  int k, d;
  double f_eq;

  for (k = 0; k < n; ++n) phi[k] = 0;

  for (d = 0; d < D; ++d)
    for (k = 0; k < n; ++n)
      phi[k] += f[n*d + k];
}