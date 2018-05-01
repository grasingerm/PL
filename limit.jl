using ArgParse;
using PyPlot;

s = ArgParseSettings();
@add_arg_table s begin
  "--x0", "-X"
    help = "lim x -> x0"
    arg_type = Float64
    default = 0.0
  "--plot-limit", "-P"
    help = "Plot limit of function"
    action = :store_true
  "function"
    help = "Function"
    required = true
end

pa = parse_args(s);

const x0 = pa["x0"];
const do_plot = pa["plot-limit"];
f = eval(parse("(x) -> " * pa["function"]));

xs = Float64[];
ys = Float64[];

lx = (x0 == Inf) ? (n) -> 10.0^(n) : (n) -> x0 + 10.0^(-n);
rx = (x0 == -Inf) ? (n) -> -10.0^(n) : (n) -> x0 - 10.0^(-n);

if x0 != Inf
  for n=0:10
    x = rx(n);
    push!(xs, x);
    push!(ys, f(x));
    println("f(", xs[end], ") = ", ys[end]);
  end
end
if x0 != -Inf
  for n=10:-1:0
    x = lx(n);
    push!(xs, x);
    push!(ys, f(x));
    println("f(", xs[end], ") = ", ys[end]);
  end
end

if do_plot
  plot(xs, ys);
  show();
end
