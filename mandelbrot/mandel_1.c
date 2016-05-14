#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct {
  double x;
  double y;
} complex;

typedef struct {
  double start;
  double end;
  double step;
} linspace;

void comp_mult(const complex* u, const complex* v, complex* result) {
  result->x = u->x * v->x - u->y * v->y;
  result->y = u->x * v->y + u->y * v->x;
}

void comp_add(const complex* u, const complex* v, complex* result) {
  result->x = u->x + v->x;
  result->y = u->y + v->y;
}

double comp_abs(const complex* u) {
  return sqrt(u->x * u->x + u->y * u->y);
}

void f(const complex* z, const complex* c, complex* result) {
  complex z_sqr;
  comp_mult(z, z, &z_sqr);
  comp_add(&z_sqr, c, result);
}

int comp2str(char* buffer, const size_t n, const complex* c) {
  return snprintf(buffer, n, "%lf + %lfi", c->x, c->y);
}

int main(int argc, char* argv[]) {
  char buffer[100];
  char buffer2[100];
  char buffer3[100];

  complex cs[10];
  for (unsigned i = 0; i < 10; ++i) {
    cs[i].x = rand() % 1000 - 500;
    cs[i].y = rand() % 1000 - 500;
  }

  for (unsigned i = 0; i < 10; ++i) {
    comp2str(buffer, 100, &cs[i]);
    printf("complex number %2d = %s\n", i, buffer);
  }

  complex c12;
  comp_add(cs, cs+1, &c12);
  comp2str(buffer, 100, cs);
  comp2str(buffer2, 100, cs+1);
  comp2str(buffer3, 100, &c12);
  printf("%s + %s = %s\n", buffer, buffer2, buffer3); 

  comp_mult(cs, cs+1, &c12);
  comp2str(buffer, 100, cs);
  comp2str(buffer2, 100, cs+1);
  comp2str(buffer3, 100, &c12);
  printf("%s * %s = %s\n", buffer, buffer2, buffer3);

  return 0;
}
