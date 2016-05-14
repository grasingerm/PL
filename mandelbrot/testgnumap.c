#include "gnuplot_i.h"
#include "unistd.h"

int main()
{
  gnuplot_ctrl *h;
  h = gnuplot_init();

  gnuplot_cmd(h, "load \"map.gp\"");

  sleep(10);

  gnuplot_close(h);

  return 0;
}
