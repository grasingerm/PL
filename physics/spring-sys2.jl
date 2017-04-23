function potential(x::Vector{Float64}, K::Matrix{Float64})
  return 0.5 * dot(x, K * x);
end

function apply_bc(x::Vector, L::Real)
  for i=1:2
    if x[i] < 0.0
      x[i] += L;
    elseif x[i] >= L
      x[i] -= L;
    end
  end
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

s = ArgParseSettings();
@add_arg_table s begin
  "--x1", "-X"
    help = "initial position of m1"
    arg_type = Float64
    default = 5.0
  "--x2", "-Y"
    help = "initial position of m2"
    arg_type = Float64
    default = 5.0
  "--length", "-L"
    help = "domain length"
    arg_type = Float64
    default = 10.0
  "--stiffness-matrix", "-K"
    help = "Stiffness matrix"
    arg_type = AbstractString
    default = "[1.0 -1.0; -1.0 1.0]"
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
    default = 1.5
  "--dx", "-D"
    help = "element size"
    arg_type = Float64
    default = 0.1
end

pa = parse_args(s); 

const x0 = [pa["x1"]; pa["x2"]];
const K = eval(parse(pa["stiffness-matrix"]));
const L = pa["length"];
@assert(typeof(K) == Matrix{Float64}, "K must be a matrix");
@assert(size(K, 1) == size(K, 2), "K must be a square matrix");
const beta = pa["beta"];
const nsteps = pa["num-steps"];
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];

xsum = zeros(2);
xsqsum = zeros(2);
xmagsum = 0.;
esum = 0.;
counter = 0;

x = x0;
xpos = copy(x);
u0 = potential(x0, K);
u = u0;

for step = 1:nsteps
  choice = rand(1:2);
  delta_x = zeros(2);
  delta_x[choice] += rand(-delta:1e-9:delta);
  xtrial = x + delta_x;
  utrial = potential(xtrial, K);
  if acc_func(u, utrial, beta)
    xpos += delta_x;
    apply_bc(xpos, L);
    x = xtrial;
    u = utrial;
  end
  xsum += xpos;
  xsqsum += map(x -> x*x, xpos);
  xmagsum += dot(xpos, xpos);
  esum += u;
  if (xpos[1] > x0[1] - dx && xpos[1] < x0[1] + dx
      && xpos[2] > x0[2] - dx && xpos[2] < x0[2] + dx)
    counter += 1;
  end
end

exp_x = xsum / nsteps;
exp_xsq = xsqsum / nsteps;
px0 = counter / (nsteps * (2 * dx)^2);
Z = exp(-beta * u0) / px0;
println("<x>      =   $(exp_x)");
println("<x^2>    =   $(exp_xsq)");
println("<|x|^2>  =   $(xmagsum / nsteps)");
println("Δx       =   $(map(i -> sqrt(exp_xsq[i] - exp_x[i] * exp_x[i]), 1:2))");
println("<E>      =   $(esum / nsteps)");
println("1/2β     =   $(0.5 / (beta))");
println("Z        =   $Z");
Z_an = 1.0;
lambdas = eigvals(K);
for lambda in lambdas
  if abs(lambda) >= 1e-10
    Z_an *= sqrt(2 * pi / (beta * lambda));
  end
end
Z_an *= 1.5*L;
println("Z       ?=   $Z_an");
