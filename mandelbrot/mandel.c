#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "gnuplot_i.h"
#include "unistd.h"

typedef struct {
  double x;
  double y;
} complex;

typedef struct {
  double start;
  double end;
  double step;
} linspace;

void swap(void** pa, void** pb) {
  void* temp = *pa;
  *pa = *pb;
  *pb = temp;
}

void comp_mult(const complex* u, const complex* v, complex* result) {
  result->x = u->x * v->x - u->y * v->y;
  result->y = u->x * v->y + u->y * v->x;
}

void comp_add(const complex* u, const complex* v, complex* result) {
  result->x = u->x + v->x;
  result->y = u->y + v->y;
}

double comp_abs(const complex* z) {
  return sqrt(z->x * z->x + z->y * z->y);
}

void f(const complex* z, const complex* c, complex* result) {
  complex z_sqr;
  comp_mult(z, z, &z_sqr);
  comp_add(&z_sqr, c, result);
}

unsigned mandel_iters(complex* pc, const unsigned maxiters) {
  complex result, zk = {0.0, 0.0};
  complex *pzk = &zk, *presult = &result;

  for (unsigned k = 0; k < maxiters; ++k) {
    f(pzk, pc, presult);
    swap((void **)(&pzk), (void **)(&presult));
    if (comp_abs(pzk) > 2) return k;
  }

  return maxiters;
}

unsigned* init_mandel_table(const linspace* cx, const linspace* cy,
                            const unsigned maxiters) {
  const unsigned n = (unsigned)ceil((cx->end - cx->start) / cx->step) + 1;
  const unsigned m = (unsigned)ceil((cy->end - cy->start) / cy->step) + 1;
  complex c, *pc = &c;

  unsigned *mtable = (unsigned*) malloc (sizeof(unsigned) * n * m);
  
  pc->x = cx->start;
  for (unsigned i = 0; i < n; ++i) {
    pc->y = cy->start;
    for (unsigned j = 0; j < m; ++j) {
      *(mtable + i * m + j) = mandel_iters(pc, maxiters);
      pc->y += cy->step;
    }
    pc->x += cx->step;
  }

  return mtable;
}

void write_table(const char* fname, const linspace* cx, const linspace* cy,
                 const unsigned *mtable) {
  const unsigned n = (unsigned)ceil((cx->end - cx->start) / cx->step) + 1;
  const unsigned m = (unsigned)ceil((cy->end - cy->start) / cy->step) + 1;
  FILE* w = fopen(fname, "w");

  double x = cx->start;
  for (unsigned i = 0; i < n; ++i) {
    double y = cy->start;
    for (unsigned j = 0; j < m; ++j) {
      fprintf(w, "%lf %lf %u\n", x, y, *(mtable + i * m + j));
      y += cy->step;
    }
    fputc('\n', w);
    x += cx->step;
  }

  fclose(w);
}

int comp2str(char* buffer, const size_t n, const complex* c) {
  return snprintf(buffer, n, "%lf + %lfi", c->x, c->y);
}

static const int plot_type = 2;

int main(int argc, char* argv[]) {
  if (argc != 8) {
    puts("mandel xstart xend xstep ystart yend ystep maxiters");
    return -1;
  }

  unsigned maxiters = strtoul(argv[7], NULL, 10);

  linspace cx = { strtod(argv[1], NULL), strtod(argv[2], NULL), 
                  strtod(argv[3], NULL) };
  linspace cy = { strtod(argv[4], NULL), strtod(argv[5], NULL), 
                  strtod(argv[6], NULL) };

  unsigned* mtable = init_mandel_table(&cx, &cy, maxiters);
  write_table("mandel.dat", &cx, &cy, mtable);

  free(mtable);

  gnuplot_ctrl *h;
  h = gnuplot_init();

  switch (plot_type) {
    case 1:
      gnuplot_cmd(h, "set view map");
      gnuplot_cmd(h, "unset key");
      gnuplot_cmd(h, "unset surface");
      gnuplot_cmd(h, "set contour");
      gnuplot_cmd(h, "set dgrid3d");
      gnuplot_cmd(h, "set cntrparam cubicspline");
      gnuplot_cmd(h, "set cntrparam levels %u", maxiters);
      gnuplot_cmd(h, "set pm3d");
      gnuplot_cmd(h, "set pm3d interpolate 20,20");
      gnuplot_cmd(h, "splot \"mandel.dat\" using 1:2:3 notitle with l");
      break;
    case 2:
      gnuplot_cmd(h, "set view map");
      gnuplot_cmd(h, "unset key");
      gnuplot_cmd(h, "splot \"mandel.dat\" matrix with image");
      break;
  }

  sleep(30);

  gnuplot_close(h);

  return 0;
}
