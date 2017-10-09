using ArgParse;
using PyPlot;

ioff();

s = ArgParseSettings();
@add_arg_table s begin
  "--pr", "-p"
    help = "probability of moving to the right"
    default = 0.5
    arg_type = Float64
  "--x0", "-x"
    help = "initial location"
    default = 1
    arg_type = Int
  "--chain-length", "-l"
    help = "number of links in chain"
    default = 5
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
  "--animate", "-A"
    help = "animate markov chain"
    action = :store_true
end

pa = parse_args(s);

const nsteps = pa["num-steps"];
const p = pa["pr"];
const x0 = pa["x0"];
const L = pa["chain-length"];
const sample_frequency = pa["sample-frequency"];
const plot_histogram = pa["plot-histogram"];
const animate = pa["animate"];

x = x0;
data = [];

for step=1:nsteps

  if rand() < p
    x = (x == L) ? L : x+1;
  else
    x = (x == 0) ? 0 : x-1;
  end

  if step % sample_frequency == 0
    push!(data, x);
    clf();
    plt["hist"](data, normed=true);
    pause(0.05);
  end

end

if plot_histogram
  clf();
  plt["hist"](data, normed=true);
  show();
end

@show data / nsteps
