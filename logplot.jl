import PyPlot;

show_plot = false;

eval(if show_plot
       :(PyPlot.ion();)
     else
       :(PyPlot.ioff();)
     end);

x = 0:10;
y = map(x -> 2.0^x, x);

PyPlot.plot(x, y);
PyPlot.yscale("log");
PyPlot.grid();

xlabel = "x";
ylabel = "2^x";

eval(if xlabel != ""
       :(PyPlot.xlabel($xlabel););
     end)
eval(if ylabel != ""
       :(PyPlot.ylabel($ylabel););
     end)

PyPlot.xlim((0.0, 20.0));
PyPlot.draw();
PyPlot.savefig("fig.png");

eval(if show_plot
      quote
          PyPlot.show();
          PyPlot.pause(0.001);
      end
     else
       :();
     end);

println("ENTER to continue");
readline(STDIN);
