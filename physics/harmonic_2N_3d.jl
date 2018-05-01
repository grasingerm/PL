function potential(x::Vector{Float64}, k::Real)
  return 0.5 * k * (dot(x[1:3], x[1:3]) + dot(x[4:6], x[4:6]));
end

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
    help = "x-component of initial position"
    arg_type = Float64
    default = 0.0
  "--y0", "-Y"
    help = "y-component of initial position"
    arg_type = Float64
    default = 0.0
  "--z0", "-Z"
    help = "z-component of initial position"
    arg_type = Float64
    default = 0.0
  "--spring-const", "-k"
    help = "Spring constant"
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
  "--nbins", "-b"
    help = "Number of bins in histogram"
    arg_type = Int
    default = 50
  "--yz-slice", "-y"
    help = "Normalized y (and z) coordinate where to take the slice"
    arg_type = Float64
    default = 0.5
end

pa = parse_args(s); 

const x0 = [pa["x0"]; pa["y0"]; pa["z0"]; pa["x0"]; pa["y0"]; pa["z0"]];
const sk = pa["spring-const"];
const beta = pa["beta"];
const nsteps = pa["num-steps"];
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];

xsum = zeros(6);
xsqsum = zeros(6);
xmagsum = 0.;
esum = 0.;
counter = 0;

x = x0;
u0 = potential(x0, sk);
u = u0;

xs = (pa["plot-histogram"]) ? zeros(6, nsteps) : zeros(1, 1);

for step = 1:nsteps
  choice = rand(1:6);
  delta_x = zeros(6);
  delta_x[choice] += rand(-delta:1e-9:delta);
  xtrial = x + delta_x;
  utrial = potential(xtrial, sk);
  if acc_func(u, utrial, beta)
    x = xtrial;
    u = utrial;
  end
  xsum += x;
  xsqsum += map(x -> x*x, x);
  xmagsum += dot(x, x);
  esum += u;
  if (x[1] > x0[1] - dx && x[1] < x0[1] + dx
      && x[2] > x0[2] - dx && x[2] < x0[2] + dx
      && x[3] > x0[3] - dx && x[3] < x0[3] + dx
      && x[4] > x0[4] - dx && x[4] < x0[4] + dx
      && x[5] > x0[5] - dx && x[5] < x0[5] + dx
      && x[6] > x0[6] - dx && x[6] < x0[6] + dx)
    counter += 1;
  end
  if pa["plot-histogram"]
    xs[:, step] = x;
  end
end

if pa["plot-histogram"]
  x_min, x_max = map(i -> minimum(xs[i, :]), 1:3), map(i -> maximum(xs[i, :]), 1:3);
  nbins = pa["nbins"];
  dxs = map(i -> (x_max[i] - x_min[i]) / (nbins - 1), 1:3);
  bins = zeros(nbins, nbins, nbins);
  for step = 1:nsteps
    i = convert(Int, div(xs[1, step] - x_min[1], dxs[1])) + 1;
    j = convert(Int, div(xs[2, step] - x_min[2], dxs[2])) + 1;
    k = convert(Int, div(xs[3, step] - x_min[3], dxs[3])) + 1;
    bins[i, j, k] += 1;
  end
  bins /= (nsteps * dxs[1] * dxs[2] * dxs[3]);
end


exp_x = xsum / nsteps;
exp_xsq = xsqsum / nsteps;
px0 = counter / (nsteps * (2 * dx)^6);
Z = exp(-beta * u0) / px0;
println("<x>      =   $(exp_x)");
println("<x^2>    =   $(exp_xsq)");
println("<|x|^2>  =   $(xmagsum / nsteps)");
println("Δx       =   $(map(i -> sqrt(exp_xsq[i] - exp_x[i] * exp_x[i]), 1:6))");
println("<E>      =   $(esum / nsteps)");
println("3/β      =   $(3 / (beta))");
println("Z        =   $Z");
Z_an = (sqrt(2 * pi / (beta * sk)))^6;
println("Z       ?=   $Z_an");

if pa["plot-histogram"]
  islice = convert(Int, floor(pa["yz-slice"] * pa["nbins"]));
  xy = dxs[2] * islice + x_min[2];
  xz = dxs[3] * islice + x_min[3];
  xs = x_min[1]:dxs[1]:(x_max[1] + dxs[1]/3.0);
  PyPlot.bar(xs, bins[:, islice, islice], dxs[1]; color="cyan");
  PyPlot.plot(xs, 
              map(xx -> begin
                    xslice = [xx; xy; xz];
                    exp(-beta * potential(xslice, sk)) / Z_an;
                  end, xs),
             "k--"; linewidth=8);
  legend(["Analytical"; "MCMC"]);
  xlabel("\$x_x\$");
  ylabel("\$P(x_x)\$");
  title("Probability density of \$\\mathbf{x} = [x_x, $(@sprintf("%.2lf", xy)), $(@sprintf("%.2lf", xz))]\$");
  show();
end
