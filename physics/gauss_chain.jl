function trap(f::Function, h::Real, x0::Real, x1::Real)
  sum = 0.5 * (f(x0) + f(x1));
  for x in (x0+h):h:(x1-h)
    sum += f(x);
  end
  return h * sum;
end

using PyPlot;
using ArgParse;

s = ArgParseSettings();
@add_arg_table s begin
  "--monomer-length", "-l"
    help = "length of monomer"
    arg_type = Float64
    default = 0.1
  "--num-monomers", "-n"
    help = "number of monomers"
    arg_type = Int
    default = 100
  "--num-trials", "-N"
    help = "number of trials"
    arg_type = Int
    default = 100000
  "--plot-histogram", "-p"
    help = "plot histogram of end-to-end length of chain"
    action = :store_true
end

pa = parse_args(s);

const l = pa["monomer-length"];
const num_monomers = pa["num-monomers"];
const num_trials = pa["num-trials"];
const b = sqrt(1.5 / (num_monomers * l * l));
const do_plot = pa["plot-histogram"];

x_sum = [0.0; 0.0; 0.0];
xsq_sum = 0.0;
rs = (!do_plot) ? zeros(1) : zeros(num_trials);

for k=1:num_trials
  x = [0.0; 0.0; 0.0];
  for i=1:num_monomers 
    const theta = rand(0:1e-9:2*pi);
    const phi = rand(0:1e-9:pi);
    const ct = cos(theta);
    const st = sin(theta);
    const cp = cos(phi);
    const sp = sin(phi);
    x += l * [ct*sp; st*sp; cp];
  end
  x_sum += x;
  const x2 = dot(x, x);
  xsq_sum += x2;
  if do_plot
    rs[k] = x2;
  end
end

println("<x>    =   $(x_sum / num_trials)");
println("<x^2>  =   $(xsq_sum / num_trials)");
println("1 / b  =   $(1 / b)");

P = r -> 4 * b^3 / sqrt(pi) * r^2 * exp(-b^2 * r^2);
println("int P(r)dr = ", trap(P, 0.0001, 0.0, 1000.0));

if do_plot
  plt[:hist](rs, 25; normed=true, facecolor="cyan");
  rlin = linspace(0, maximum(rs), 1000);
  plot(rlin, map(r -> 4 * b^3 / sqrt(pi) * r^2 * exp(-b^2 * r^2), rlin), "k--";
                 linewidth=5);
  legend(["Analytical"; "MC"]);
  xlabel("\$r\$");
  ylabel("\$P(r)\$");
  title("Gaussian chain, probability of end-to-end length, \$r\$");
  if 6 / b < maximum(rs)
    xlim([0.0; 6 / b]);
  end
  show();
end
