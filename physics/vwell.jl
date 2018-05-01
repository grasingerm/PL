function metropolis(u0::Real, u1::Real, beta::Real)
  if u1 <= u0
    return true;
  else
    return (rand() <= exp(-beta * (u1 - u0)));
  end
end

function kawasaki(u0::Real, u1::Real, beta::Real)
  const dU = u1 - u0;
  const enbdu = exp(-beta * dU / 2);
  const epbdu = exp(beta * dU / 2);
  return ( rand() <= (enbdu / (enbdu + epbdu)) );
end

using ArgParse;
using PyPlot;

s = ArgParseSettings();
@add_arg_table s begin
  "--x0", "-X"
    help = "initial position"
    arg_type = Float64
    default = 0.0
  "--well-slope", "-m"
    help = "alpha in V(x) = alpha * |x|"
    arg_type = Float64
    default = 1.0
  "--beta", "-B"
    help = "1 / kT"
    arg_type = Float64
    default = 1.0
  "--num-steps", "-n"
    help = "number of steps"
    arg_type = Int
    default = 1000000
  "--accept", "-a"
    help = "acceptance criteria"
    arg_type = AbstractString
    default = "metropolis"
  "--delta", "-d"
    help = "maximum step size"
    arg_type = Float64
    default = 0.5
  "--dx", "-D"
    help = "element size"
    arg_type = Float64
    default = 0.1
  "--plot-histogram", "-p"
    help = "Plot histogram of positions"
    action = :store_true
end

pa = parse_args(s);

potential(a::Real, x::Real) = a * abs(x);

const x0 = pa["x0"];
const a = pa["well-slope"];
const beta = pa["beta"];
const nsteps = pa["num-steps"];
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];

xsum = 0.0;
xsqsum = 0.0;
esum = 0.0;
counter = 0;

x = x0;
u = potential(a, x);

xs = (pa["plot-histogram"]) ? zeros(nsteps) : zeros(1);

for step = 1:nsteps
  xtrial = x + rand(-delta:1e-9:delta);
  utrial = potential(a, xtrial);
  if acc_func(u, utrial, beta)
    x = xtrial;
    u = utrial;
  end
  xsum += x;
  xsqsum += x*x;
  esum += u;
  if x > x0 - dx && x < x0 + dx
    counter += 1;
  end
  if pa["plot-histogram"]
    xs[step] = x;
  end
end

exp_x = xsum / nsteps;
exp_xsq = xsqsum / nsteps;
px0 = counter / nsteps;
Z_an = 2 / (beta * a);
exp_x0 = counter / (nsteps * 2 * dx);
Z1 = exp(-beta * potential(a, x0)) / exp_x0;
println("<x>      =   $(exp_x)");
println("<x^2>    =   $(exp_xsq)");
println("Δx       =   $(sqrt(exp_xsq - exp_x^2))");
println("<E>      =   $(esum / nsteps)");
println("1 / β    =   $(1 / beta)");
println("Z        =   $Z1");
println("Z (an)   =   $Z_an");

println("< δ(x - x0) > = $exp_x0");

if pa["plot-histogram"]
  plt[:hist](xs, 25; normed=true, facecolor="cyan");
  x_min, x_max = minimum(xs), maximum(xs);
  xline = linspace(x_min, x_max, 100);
  PyPlot.plot(xline, 
              map(x -> exp(-beta * potential(a, x)) / Z_an, xline),
             "k--"; linewidth=8);
  legend(["MCMC", "Analytical"]);
  xlabel("\$x\$");
  ylabel("\$P(x)\$");
  title("Harmonic Oscillator, probability density of \$x\$");
  show();
end
