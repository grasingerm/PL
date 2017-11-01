using Distributions;
using PyPlot;
using ArgParse;

s = ArgParseSettings();
@add_arg_table s begin
  "--param1"
    help = "first parameter of distribution"
    arg_type = Float64
    default = 2.4
  "--param2"
    help = "second parameter of distribution"
    arg_type = Float64
    default = 1.7
  "--dist"
    help = "distribution, options: Normal, Laplace, Gamma, Frechet, Cauchy, Beta, BetaPrime, Arcsine, Pareto, Uniform, VonMises, Weibull"
  "--num-of-samples"
    help = "number of samples"
    arg_type = Int
    default = 100
  "--num-per-sample"
    help = "number of samples per sample"
    arg_type = Int
    default = 4
  "--plot-histogram", "-P"
    help = "Plot histogram of positions"
    action = :store_true
  "--print-samples", "-Q"
    help = "Print sample means"
    action = :store_true
  "--bins", "-B"
    help = "Histogram bins"
    arg_type = Int
    default = 25
  "seed"
    help = "random number generator seed"
    arg_type = Int
end

pa = parse_args(s);
if (pa["seed"] != nothing)
  srand(pa["seed"]);
end

const distname = pa["dist"];
const param1 = pa["param1"];
const param2 = pa["param2"];
d = try
  eval(parse("$distname($param1, $param2)"));
catch e
  warn("Unable to construct distribution: $distname with parameters $param1, $param2");
  rethrow(e);
end

const n = pa["num-of-samples"];
const m = pa["num-per-sample"];
samples = zeros(n);

for k=1:n
  local_sum = @parallel (+) for l=1:m
    rand(d);
  end
  samples[k] = local_sum / m;
end

if pa["plot-histogram"]
  plt[:hist](samples, 25; normed=true);
  xlabel("\$\\mu\$");
  ylabel("frequency");
  title("Central limit theorem, $distname: \$p_1 = $(param1), p_2 = $param2\$");
  show();
end

if pa["print-samples"]
  println(samples);
end
