using ArgParse;
using PyPlot;

ioff();

s = ArgParseSettings();
@add_arg_table s begin
  "--pr", "-p"
    help = "probability of moving to the right"
    default = 0.5
    arg_type = Float64
  "--step-length", "-b"
    help = "step length"
    default = 2.3
    arg_type = Float64
  "--x0", "-x"
    help = "initial location"
    default = 0
    arg_type = Int
  "--num-steps", "-N"
    help = "number of steps"
    default = 100000
    arg_type = Int
  "--sample-frequency", "-n"
    help = "steps between samples"
    default = 100
    arg_type = Int
  "--plot-histogram", "-P"
    help = "steps between samples"
    action = :store_true
  "--plot-exact", "-E"
  help = "plot exact distribution (with Gaussian and numerical approx)"
    action = :store_true
end

pa = parse_args(s);

const nsteps = pa["num-steps"];
const p = pa["pr"];
const x0 = pa["x0"];
const sample_frequency = pa["sample-frequency"];
const plot_histogram = pa["plot-histogram"];
const plot_exact = pa["plot-histogram"];

x = x0;
data = [];

for step=1:nsteps

  if rand() < p
    x += b;
  else
    x -= b;
  end

  if step % sample_frequency == 0
    push!(data, x);
    clf();
    plt["hist"](data, normed=true);
    pause(0.005);
  end

end

if plot_histogram
  clf();
  plt["hist"](data, normed=true);
  show();
end
