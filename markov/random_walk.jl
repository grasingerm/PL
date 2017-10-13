using ArgParse;
using PyPlot;
using Distributions;

ioff();

function gauss_approx(b::Real, N::Int, p::Real, x::Real)
  mu = (2*p - 1) * N * b;
  sgs = 4*b*b*N*p*(1-p);
  return exp(-(x-mu)^2 / (2*sgs)) / (sqrt(2*pi*sgs));
end

function bin_dist(b::Real, N::Int, p::Real)
  xs = zeros(N+1);
  probs = zeros(N+1);
  pm = 1.0;
  pN = (1-p)^N;
  for m=0:N
    numerator = pm*pN;
    val = if m > N/2
      for i=(m+1):N
        numerator *= i;
      end
      numerator / factorial(big(N-m));
    else
      for i=(N-m+1):N
        numerator *= i;
      end
      numerator / factorial(big(m));
    end
    pm *= p;
    pN /= (1-p);
    xs[m+1] = (2*m - N)*b;
    probs[m+1] = val;
  end
  return xs, probs;
end

s = ArgParseSettings();
@add_arg_table s begin
  "--pr", "-p"
    help = "probability of moving to the right"
    default = 0.5
    arg_type = Float64
  "--step-length", "-b"
    help = "step length"
    default = 2.0
    arg_type = Float64
  "--x0", "-x"
    help = "initial location"
    default = 0
    arg_type = Int
  "--num-steps", "-N"
    help = "number of steps"
    default = 100000
    arg_type = Int
  "--num-samples", "-n"
    help = "number of random walk samples"
    default = 100
    arg_type = Int
  "--animate", "-A"
    help = "plot histogram"
    action = :store_true
  "--plot-exact", "-E"
  help = "plot exact distribution (with Gaussian and numerical approx)"
    action = :store_true
end

pa = parse_args(s);

const nsteps = pa["num-steps"];
const nsamples = pa["num-samples"];
const p = pa["pr"];
const x0 = pa["x0"];
const b = pa["step-length"];
const animate = pa["animate"];
const plot_exact = pa["plot-exact"];

data = [];

for sample=1:nsamples

  x = x0;
  x += b * @parallel (+) for step=1:nsteps
    (rand() < p) ? 1 : -1;
  end

  push!(data, x);
  if animate
    clf();
    plt["hist"](data, normed=true);
    pause(1e-6);
  end

end

clf();
plt["hist"](data, normed=true);
min_x, max_x = minimum(data), maximum(data);
xs = min_x:1e-1:max_x;
plot(xs, map(x -> gauss_approx(b, nsteps, p, x), xs); label="Gauss approx.",
     linewidth=7);
if plot_exact
  xs, ps = bin_dist(b, nsteps, p);
  @show sum(ps);
  plot(xs, ps, "x"; label="Exact distribution");
end
legend();
show();
