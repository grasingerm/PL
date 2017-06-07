function potential(x::Vector{Float64}, K::Matrix{Float64})
  return 1/2 * dot(x, K*x);
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
  "--beta", "-B"
    help = "1 / kT"
    arg_type = Float64
    default = 2.0
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
  "--k1", "-K"
    help = "first spring constant"
    arg_type = Float64
    default = 1.0
  "--k2", "-L"
    help = "second spring constant"
    arg_type = Float64
    default = 1.0
  "--kg", "-G"
    help = "spring constant for constraint"
    arg_type = Float64
    default = 100.0
  "--r0", "-r"
  help = "end to end distance"
    arg_type = Float64
    default = 1.0
  "--output-step", "-O"
    help = "Frequency with which to output step (% complete)"
    arg_type = Float64
    default = 0.1
end

pa = parse_args(s); 

const k1 = pa["k1"];
const k2 = pa["k2"];
const kg = pa["kg"];
const r = pa["r0"];
const beta = pa["beta"];
const Kexact = [k1+k2 -k2; -k2 k2];
const K = [k1+k2 -k2; -k2 k2+kg];
@assert(isposdef(Kexact));
@assert(isposdef(K));
const V = eigvecs(K);
const Lambda = V * K * V';
@assert(abs(Lambda[1, 2]) < 1e-10);
@assert(abs(Lambda[2, 1]) < 1e-10);
const b = V*[0.0; -kg * r];
Z = (exp(-beta/2 * ((kg * r^2) - b[1]^2 / Lambda[1, 1] - b[2]^2 / Lambda[2, 2])) *
     sqrt(2 * pi / (beta * Lambda[1, 1])) * sqrt(2 * pi / (beta * Lambda[2, 2])));

const nsteps = pa["num-steps"];
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];
const output_step = Int(round(nsteps * pa["output-step"]));
const x0 = [0.5*r; r];
const u0 = potential(x0, Kexact);

x = copy(x0);
u = u0;

xsum = zeros(2);
xsqsum = zeros(2);
usum = 0.0;
usqsum = 0.0;
nsamples = 0;
counter = 0;

for step = 1:nsteps
  xtrial = copy(x);
  xtrial[1] += rand(-delta:1e-9:delta);
  utrial = potential(xtrial, Kexact);
  
  if acc_func(u, utrial, beta)
    x = xtrial;
    u = utrial;
  end

  xsum += x;
  xsqsum += map(y -> y*y, x);
  usum += u;
  usqsum += u*u;
  nsamples += 1;
  if x[1] >= x0[1]-dx && x[1] <= x0[1]+dx
    counter += 1;
  end
  
  if step % output_step == 0
    println(step, " / ", nsteps);
  end
end

exp_x = xsum / nsamples;
exp_xsq = xsqsum / nsamples;
px0 = counter / (nsamples * (2 * dx));
Z_approx = exp(-beta * u0) / px0;
exp_E = usum / nsamples;
exp_E2 = usqsum / nsamples;
println("delta             =   $delta;");
println("beta              =   $beta;");
println("k1                =   $k1;");
println("k2                =   $k2;");
println("u0                =   $u0;");
println("exp_x             =   $(exp_x);");
println("exp_x2            =   $(exp_xsq);");
println("Delta_x           =   $(sqrt(exp_xsq - map(x -> x*x, exp_x)));");
println("exp_E             =   $exp_E;");
println("exp_E2            =   $exp_E2;");
println("Delta_E           =   $(sqrt(exp_E2 - exp_E*exp_E));");
println("Z_approx          =   $Z_approx;");
println("Z                 =   $Z;");
