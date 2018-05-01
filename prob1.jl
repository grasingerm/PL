using ArgParse

s = ArgParseSettings();
@add_arg_table s begin
  "--num-trials", "-N"
    help = "number of trials"
    arg_type = Int
    default = 100000
end

pa = parse_args(s);
const num_trials = pa["num-trials"];

num_hits = @parallel (+) for i=1:num_trials
  x1 = rand();
  x2 = rand();

  Int(x1 + x2 < 1 && x1*x2 <= 2 / 9);
end

println("approximate P(A)   =   $(num_hits / num_trials)");
println("analytical  P(A)   =   $((2/3)^2 + 2/9*log(2/3) - (1/3)^2 - 2/9*log(1/3))");
