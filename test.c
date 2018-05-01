#include <stdio.h>

void f1(double* x) {
  *x = 4.0;
}

void f2(double x) {
  x = 5.0;
}

void f3(double **px, double *x) {
  *px = x;
}

void f4(double& x) {
  x = 1.1;
}

int main() {
  double y = 1.0;
  f1(&y);
  printf("y = %lf\n", y);
  
  f2(y);
  printf("y = %lf\n", y);

  double *z = &y;
  printf("*z = %lf\n", *z);

  double x = 2.0;
  double **pz = &z;
  double *px = &x;
  f3(pz, px);
  printf("*z = %lf\n", *z); // *z = 2.0

  f4(x);
  printf("*z = %lf\n", *z);

  return 0;
}
