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
    default = 0.2
  "--k1", "-K"
    help = "first spring constant"
    arg_type = Float64
    default = 0.5
  "--k2", "-L"
    help = "second spring constant"
    arg_type = Float64
    default = 1.5
  "--output-step", "-O"
    help = "Frequency with which to output step (% complete)"
    arg_type = Float64
    default = 0.1
end

pa = parse_args(s); 

const k1 = pa["k1"];
const k2 = pa["k2"];
const K = [k1+k2 -k2; -k2 k2];

const nsteps = pa["num-steps"];
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];
const output_step = Int(round(nsteps * pa["output-step"]));

for step = 1:nsteps
  choice = rand(1:5);
  xtrial = copy(x);
  xtrial[choice] += rand(-delta:1e-9:delta);
  
  if step % output_step == 0
    println(step, " / ", nsteps);
  end
end

exp_x = xsum / nsamples;
exp_xsq = xsqsum / nsamples;
px0 = counter / (nsamples * (2 * dx)^3 * (2 * dtheta)^2);
Zprop = 1 / px0;
Z = exp(0) * Zprop;
exp_E = esum / nsamples;
exp_E2 = esqsum / nsamples;
println("delta             =   $delta;");
println("beta              =   $beta;");
println("k1                =   $k1;");
println("k2                =   $k2;");
println("E0                =   $E0;");
println("n0                =   $n0;");
println("p0                =   $p0;");
println("u0                =   $u0;");
println("exp_x             =   $(exp_x);");
println("exp_x2            =   $(exp_xsq);");
println("Delta_x           =   $(sqrt(exp_xsq - map(x -> x*x, exp_x)));");
println("exp_pmag          =   $(pmagsum / nsamples);");
println("exp_E             =   $exp_E;");
println("exp_E2            =   $exp_E2;");
println("Delta_E           =   $(sqrt(exp_E2 - exp_E*exp_E));");
println("exp_E_abs_error   =   $(e_abs_error_sum / nsamples);");
println("exp_E_sq_error    =   $(e_sq_error_sum / nsamples);");
println("Z_approx          =   $Z;");
