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
using PyPlot;

s = ArgParseSettings();
@add_arg_table s begin
  "--x0", "-X"
    help = "initial position"
    arg_type = String
    default = "[2.0; 4.0]"
  "--r0", "-R"
    help = "prescribed end-to-end vector"
    arg_type = String
    default = "[3.0; 6.0]"
  "--k1", "-K"
    help = "1st spring constant"
    arg_type = Float64
    default = 1.5
  "--k2", "-L"
    help = "2nd spring constant"
    arg_type = Float64
    default = 3.0
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
    default = 0.05
  "--output-step", "-O"
    help = "Frequency with which to output step (% complete)"
    arg_type = Float64
    default = 0.1
end

pa = parse_args(s);

function harmonic_potential(k1::Real, k2::Real, x::Vector{Float64})
  return (0.5 * (k1 * dot(x[1:2], x[1:2]) + 
                 k2 * dot(x[3:4]-x[1:2], x[3:4]-x[1:2])));
end

const x0 = eval(parse(pa["x0"]));
const r0 = eval(parse(pa["r0"]));
const k1 = pa["k1"];
const k2 = pa["k2"];
const beta = pa["beta"];
const nsteps = pa["num-steps"];
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];
const output_step = Int(round(nsteps * pa["output-step"]));

xsum = 0.0;
xsqsum = 0.0;
esum = 0.0;
counter = 0;

x = vcat(x0, r0);
u = harmonic_potential(k1, k2, x);
const u0 = u;

for step = 1:nsteps
  xtrial = x + vcat(rand(-delta:1e-9:delta, 2), zeros(2));
  utrial = harmonic_potential(k1, k2, xtrial);
  if acc_func(u, utrial, beta)
    x = xtrial;
    u = utrial;
  end
  xsum += x;
  xsqsum += map(xi -> xi*xi, x);
  esum += u;

  if x[1] > x0[1] - dx && x[1] < x0[1] + dx
     x[2] > x0[2] - dx && x[2] < x0[2] + dx
    counter += 1;
  end
  
  if step % output_step == 0
    println(step, " / ", nsteps);
  end

end

r = [0; 0; 0; 0; -im * r0[1]; -im * r0[2]];
K = [beta*(k1+k2)/2         0                 -beta*k2/2      0           0       0;
     0                      beta*(k1+k2)/2    0               -beta*k2/2  0       0;
     -beta*k2/2             0                 beta*k2/2       0           -im/2   0;
     0                      -beta*k2/2        0               beta*k2/2   0       -im/2;
     0                      0                 -im/2           0           0       0;
     0                      0                 0               -im/2       0       0];

lambdas, V = eig(K);
diagonalized = transpose(V) * K * V;
for i=1:6, j=1:6
  if i == j; continue; end
  if abs(diagonalized[i, j]) > 1e-9
    warn("Stiffness matrix was not properly diagonalized");
  end
end
q = transpose(V)*r;
println("\ndebug info...");
@show K - transpose(K)
@show lambdas, V
@show diagonalized
@show q
println();

sm = 0.;
for k=1:6; sm += q[k]^2/(4*lambdas[k]); end
Z_an = real(exp(sm) / (2*pi)^2 * sqrt(pi^6 / det(K)));
inv_eigs = map(k -> 1 / (2 * lambdas[k]), 1:6);
xsq_an = map(k -> 1 / (2 * lambdas[k]) + q[k]^2 / (4 * lambdas[k]^2), 1:6);

exp_x = xsum / nsteps;
exp_xsq = xsqsum / nsteps;
px0 = counter / nsteps;
exp_x0 = counter / (nsteps * (2 * dx)^2);
Z1 = exp(-beta * u0) / exp_x0;
println("<x>        =   $(exp_x)");
println("<x^2>      =   $(exp_xsq)");
println("<x^2> (an) =   $(xsq_an)");
println("1 / 2 λ    =   $(inv_eigs)");
println("Δx         =   $(sqrt(exp_xsq - map(xi->xi*xi, exp_x)))");
println("<E>        =   $(esum / nsteps)");
println("1/2β       =   $(1 / (2*beta))");
println("Z          =   $Z1");
println("Z (an)     =   $Z_an");
println("< δ(x - x0) > = $exp_x0");
println("|K|        =   $(det(K))");
