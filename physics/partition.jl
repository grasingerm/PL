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

s = ArgParseSettings();
@add_arg_table s begin
  "--x0", "-X"
    help = "initial position"
    arg_type = Float64
    default = 0.0
  "--spring-const", "-K"
    help = "spring constant"
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
end

pa = parse_args(s);

harmonic_potential(k::Real, x::Real) = 0.5 * k * x*x;

const x0 = pa["x0"];
const k = pa["spring-const"];
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
u = harmonic_potential(k, x);

for step = 1:nsteps
  xtrial = x + rand([-delta; delta]);
  utrial = harmonic_potential(k, xtrial);
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
end

exp_x = xsum / nsteps;
exp_xsq = xsqsum / nsteps;
px0 = counter / nsteps;
Z = exp(-beta * harmonic_potential(k, x0)) / px0 / 2;
println("<x>    =   $(exp_x)");
println("<x^2>  =   $(exp_xsq)");
println("Δx     =   $(sqrt(exp_xsq - exp_x^2))");
println("<E>    =   $(esum / nsteps)");
println("1/2β   =   $(1 / (2*beta))");
println("Z      =   $Z");
println("Z (an) =   $(sqrt(2 * pi / (beta * k)))");
