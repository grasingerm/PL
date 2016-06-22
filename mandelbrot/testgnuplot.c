#include "gnuplot_i.h"
#include "unistd.h"

int main()
{
  gnuplot_ctrl *h;
  h = gnuplot_init();

  gnuplot_set_xlabel(h, "x");
  gnuplot_set_ylabel(h, "sin(x)");

  gnuplot_cmd(h, "plot sin(x)");

  sleep(10);

  gnuplot_close(h);

  return 0;
}
