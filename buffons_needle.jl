using ArgParse;

s = ArgParseSettings();
@add_arg_table s begin
  "--needle-length", "-l"
    help = "length of needle"
    arg_type = Float64
    default = 1.0
  "--partition-size", "-L"
    help = "distance between lines"
    arg_type = Float64
    default = 2.5
  "--num-trials", "-n"
    help = "number of trials"
    arg_type = Int
    default = 1000000
end

pa = parse_args(s);

const l = pa["needle-length"];
const L = pa["partition-size"];
const num_trials = pa["num-trials"];

num_intersections = @parallel (+) for i=1:num_trials
  const theta = rand(0:1e-9:pi);
  const x = rand(0:1e-9:L);
  Int(x < l * sin(theta));
end

println("Probability of intersection");
println("   approximate: $(num_intersections / num_trials)");
println("    analytical: $(2 * l / (pi * L))");
println();

println("Value of pi");
println("   approximate: $(2 * l / L * num_trials / num_intersections)");
println("    analytical: $(pi)");
