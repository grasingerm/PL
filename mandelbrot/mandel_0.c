#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <argp.h>

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
  result->y = u->x * v->y + u->y * u->x;
}

int comp2str(char* buffer, const size_t n, const complex* c) {
  return snprintf(buffer, n, "%lf + %lfi", c->x, c->y);
}

const char *argp_program_version = "mandel 1.0";
const char *argp_program_bug_address = "<grasingerm@gmail.com>";
static char doc[] = "some kind of program to generate mandelbrot set";

static struct argp argp = { 0, 0, 0, doc };

int main(int argc, char* argv[]) {
  argp_parse(&argp, argc, argv, 0, 0, 0);

  char buffer[100];
  complex cs[10];
  for (unsigned i = 0; i < 10; ++i) {
    cs[i].x = rand() % 1000 - 500;
    cs[i].y = rand() % 1000 - 500;
  }

  for (unsigned i = 0; i < 10; ++i) {
    comp2str(buffer, 100, &cs[i]);
    printf("complex number %2d = %s\n", i, buffer);
  }

  return 0;
}
