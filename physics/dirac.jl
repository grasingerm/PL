ccall(:jl_exit_on_sigint, Void, (Cint,), 0); # Allows Ctrl+C to be caught
using PyPlot;
PyPlot.ioff();

k = (length(ARGS) > 0) ? parse(ARGS[1]) : 2.5;
dx = (length(ARGS) > 1) ? parse(ARGS[2]) : 5;
npts = (length(ARGS) > 2) ? parse(ARGS[3]) : 100000;
nk = (length(ARGS) > 3) ? parse(ARGS[4]) : 5;
integrate = (length(ARGS) > 4) ? eval(parse(ARGS[5])) : true;

function trap(f::Function, x0::Real, x1::Real, npts::Int)
  sum = 0.5 * (f(x0) + f(x1));
  h = (x1 - x0) / (npts-1);
  for x in (x0+h):h:(x1-h)
    sum += f(x);
  end
  return h * sum;
end

a = 1.0;
xs = linspace(-dx, dx, npts);
for iteration = 1:nk
  plot(xs, map(x -> sin(x*a)/(2*pi*x), xs));
  title("\$k = $k, a = 10^{$(convert(Int, round(log(10, a))))}\$");
  draw();
  PyPlot.pause(2.0);
  if integrate
    println("integration => $(trap(x -> sin(x*a)/(pi*x), -dx, dx, npts))");
  end
  clf();
  a *= 10.0;
end
