using PyPlot;
PyPlot.ioff();

waves = (length(ARGS) > 0) ? parse(ARGS[1]) : 5;
dx = (length(ARGS) > 1) ? eval(parse(ARGS[2])) : 2*pi;
movie = (length(ARGS) > 2) ? eval(parse(ARGS[3])) : true; 
npts = (length(ARGS) == 4) ? eval(parse(ARGS[4])) : 1000; 

xs = linspace(-dx, dx, npts);

for (f, name) in zip([sin; cos], ["\\sin", "\\cos"])
  if movie
    sp = zeros(npts, waves+1);
    for k = 1:waves
      wk = map(x -> f(k * x), xs);
      sp[:, k+1] = sp[:, k] + wk;
      plot(xs, wk; label="\$k = $k\$");
      legend();
      xlabel("\$x\$");
      ylabel("\$\\psi\$");
      title("\$\\psi(x) = $name(kx)\$");
      draw();
      PyPlot.pause(2.0);
    end
    println("ENTER to continue...");
    readline(STDIN);
    clf();

    for k = 1:waves+1
      plot(xs, sp[:, k]);
      xlabel("\$x\$");
      ylabel("\$\\psi\$");
      title("$(k-1) superposed waves, \$\\psi(x) = $name(kx)\$");
      draw();
      PyPlot.pause(2.0);
      clf();
    end
    println("ENTER to continue...");
    readline(STDIN);

    for k = 1:waves+1
      plot(xs, map(y -> y*y, sp[:, k]));
      xlabel("\$x\$");
      ylabel("\$|\\psi|^2\$");
      title("$(k-1) superposed waves, \$\\psi(x) = $name(kx)\$");
      draw();
      PyPlot.pause(2.0);
      clf();
    end
    println("ENTER to continue...");
    readline(STDIN);
  else #skip movie
    sp = zeros(npts)
    for k = 1:waves
      wk = map(x -> f(k * x), xs);
      sp +=  wk;
    end
    plot(xs, sp);
    xlabel("\$x\$");
    ylabel("\$\\psi\$");
    title("$waves superposed waves, \$\\psi(x) = $name(kx)\$");
    show();
    clf();

    plot(xs, map(y -> y*y, sp));
    xlabel("\$x\$");
    ylabel("\$|\\psi|^2\$");
    title("$waves superposed waves, \$\\psi(x) = $name(kx)\$");
    show();
  end
end
