function potential(x::Vector{Float64},
                   inv_chi::Function, E0::Vector{Float64})
  p = view(x, 1:3);
  cphi = cos(x[4]);
  sphi = sin(x[4]);
  ctheta = cos(x[5]);
  stheta = sin(x[5]);
  n = [cphi * stheta; sphi * stheta; ctheta];
  return 0.5 * dot(p, inv_chi(n) * p) - dot(p, E0);
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
  "--E0", "-E"
    help = "magnitude electric field"
    arg_type = Float64
    default = 1.5
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
  "--dtheta", "-T"
    help = "element angle size"
    arg_type = Float64
    default = 0.2
  "--k1", "-K"
    help = "first susceptibility parameter"
    arg_type = Float64
    default = 0.5
  "--k2", "-L"
    help = "second susceptibility parameter"
    arg_type = Float64
    default = 1.5
  "--write-E-surface", "-W"
    help = "Write energy surface to file"
    action = :store_true
  "--sample-frequency", "-S"
    help = "Frequency with which to sample for data file"
    arg_type = Int
    default = 25
  "--output-step", "-O"
    help = "Frequency with which to output step (% complete)"
    arg_type = Float64
    default = 0.1
  "--phi", "-p"
    help = "IF k2 > k1, this is the intial angle of the monomer direction"
    arg_type = Float64
    default = pi / 2
  "--anti-align", "-A"
    help = "IF k1 > k2, this is sets the monomer to anti-align with E field"
    action = :store_true
end

pa = parse_args(s); 

const phi = pa["phi"];
const anti_align = pa["anti-align"];
const k1 = pa["k1"];
const k2 = pa["k2"];
if k1 > k2
  const n0 = (anti_align) ? [0.0; 0.0; -1.0] : [0.0; 0.0; 1.0];
elseif k2 > k1
  const n0 = [cos(phi); sin(phi); 0.0];
else
  error("k1 cannot equal k2. Susceptibility is ill-defined."); 
end

const E0 = [0.0; 0.0; pa["E0"]];
const p0 = (k1 > k2) ? k1 * E0 : k2 * E0;
const n0_angles = (k1 > k2) ? ((anti_align) ? [phi; pi] : [phi; 0]) : [phi; pi / 2];
const beta = pa["beta"];
const nsteps = pa["num-steps"];
inv_chi(n) = 1/k1 * n * n' + 1/k2 * (eye(3) - n * n');
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];
const dtheta = pa["dtheta"];
const dsample = pa["sample-frequency"];
const write_datafile = pa["write-E-surface"];
const output_step = Int(round(nsteps * pa["output-step"]));

sp, st = sin(n0_angles[1]), sin(n0_angles[2]);
cp, ct = cos(n0_angles[1]), cos(n0_angles[2]);
s2p, s2t = sin(2*n0_angles[1]), sin(2*n0_angles[2]);
c2p, c2t = cos(2*n0_angles[1]), cos(2*n0_angles[2]);
const upper_right = [(k1-k2)*st*st*(-p0[2]*c2p+p0[3]*cot(n0_angles[2])*sp+p0[1]*s2p) (-((k1-k2)*cp*(p0[3]*c2t+s2t*(p0[1]*cp+p0[2]*sp))));
                     (k1-k2)*st*st*(p0[1]*c2p+p0[3]*cot(n0_angles[2])*cp+p0[2]*s2p) (-((k1-k2)*sp*(p0[3]*c2t+s2t*(p0[1]*cp+p0[2]*sp))));
                     (k1-k2)*ct*st*(-p0[2]*cp+p0[1]*sp) -((k1-k2)*(p0[3]*s2t+c2t*(p0[1]*cp+p0[2]*sp)))
                    ] / (k1*k2);
const bottom_left = [st*(p0[3]*ct*(p0[1]*cp+p0[2]*sp)+st*((p0[1]-p0[2])*(p0[1]+p0[2])*c2p+2*p0[1]*p0[2]*s2p)) -(p0[2]*cp-p0[1]sp)*(p0[3]*c2t+s2t*(p0[1]*cp+p0[2]*sp));
                     -(p0[2]*cp-p0[1]*sp)*(p0[3]*c2t+s2t*(p0[1]*cp+p0[2]*sp)) (-4*p0[3]*s2t*(p0[1]*cp+p0[2]*sp)+c2t*(p0[1]^2+p0[2]^2-2*p0[3]^2+(p0[1]-p0[2])*(p0[1]+p0[2])*c2p+2*p0[1]*p0[2]*s2p))] * (k1-k2) / (k1*k2);
const KK = vcat(hcat(inv_chi(n0), upper_right), hcat(upper_right', bottom_left));
@assert(norm(KK - KK', Inf) < 1e-9);
approx_potential(x) = begin
  return 1/2 * dot(x, KK*x);
end

xsum = zeros(5);
xsqsum = zeros(5);
pmagsum = 0.;
esum = 0.;
esqsum = 0.;
e_abs_error_sum = 0.;
e_sq_error_sum = 0.;
counter = 0;
nsamples = 0;

x0 = vcat(p0, n0_angles);
u0 = potential(x0, inv_chi, E0);
u = 0.0;
x = copy(x0);

p, t = n0_angles[1], n0_angles[2];
ntest = [sin(t)*cos(p); sin(t)*sin(p); cos(t)];
@assert(k1 > k2 || abs(dot(n0, p0)) < 1e-10);
@assert(k2 > k1 || norm(n0 * dot(n0, p0) - p0) < 1e-10);
@assert(k1 > k2 || abs(dot(ntest, p0)) < 1e-10);
@assert(k2 > k1 || norm(ntest * dot(ntest, p0) - p0) < 1e-10);
@assert(abs(norm(n0)-1) < 1e-10);
@assert(abs(norm(ntest)-1) < 1e-10);
@assert(abs(norm(ntest-n0)) < 1e-10);

datafile = ((write_datafile) ? 
            open(joinpath("data",
                          @sprintf("energy-surface-3d_k1-%02d_k2-%02d_beta-%06d.csv",
                                   Int(round(k1*10)), Int(round(k2*10)), Int(round(beta*1000)))), "w") :
             nothing);

for step = 1:nsteps
  choice = rand(1:5);
  xtrial = copy(x);
  xtrial[choice] += rand(-delta:1e-9:delta);
  if choice == 4
    if xtrial[choice] < 0
      xtrial[choice] += 2*pi;
    elseif xtrial[choice] > 2*pi
      xtrial[choice] -= 2*pi;
    end
  elseif choice == 5
    if xtrial[choice] < 0
      xtrial[choice] += pi;
    elseif xtrial[choice] > pi
      xtrial[choice] -= pi;
    end
  end
  utrial = potential(xtrial, inv_chi, E0) - u0;
  if acc_func(u, utrial, beta)
    x = xtrial;
    u = utrial;
  end
  if step % dsample == 0
    nsamples += 1;
    xsum += x;
    xsqsum += map(a -> a*a, x);
    p = view(x, 1:3);
    pmagsum += dot(p, p);
    esum += u; # only count energy relative to equilibrium
    esqsum += u*u;
    e_abs_error_sum = abs(u - approx_potential(x));
    e_sq_error_sum = (u - approx_potential(x))^2;
    if (x[1] > x0[1] - dx && x[1] < x0[1] + dx
        && x[2] > x0[2] - dx && x[2] < x0[2] + dx
        && x[3] > x0[3] - dx && x[3] < x0[3] + dx
        && x[4] > x0[4] - dtheta && x[4] < x0[4] + dtheta
        && x[5] > x0[5] - dtheta && x[5] < x0[5] + dtheta)
      counter += 1;
    end
    if write_datafile
      for a in x
        write(datafile, "$a,");
      end
      write(datafile, "$u\n");
    end
  end

  if step % output_step == 0
    println(step, " / ", nsteps);
  end
end

if write_datafile; close(datafile); end

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

cphi = cos(n0[1]);
sphi = sin(n0[1]);
ctheta = cos(n0[2]);
stheta = sin(n0[2]);
@assert(size(KK) == (6, 6));
lambdas = eigvals(KK);
plambda = 1.0;
Z_an = 1.0;
for lambda in lambdas
  @assert(lambda > -1e-7, "negative eigenvalue: $lambda");
  if abs(lambda) > 1e-11
    plambda *= lambda;
    Z_an *= sqrt(2 * π / (beta * lambda));
  end
end
println("lambdas           =   $lambdas");
println("plambdas          =   $plambda");
plambdas_an = (k1 > k2) ? dot(E0, E0) * (k1 - k2) / (k1 * k2^2) : dot(E0, E0) * (k2 - k1) / (k1 * k2^2) ;
@assert(abs(plambda-plambdas_an)/plambda < 5e-2, "incorrect prediction of product of eigenvalues");
println("plambdas_an       =   $plambdas_an");
println("Z_an              =   $Z_an;");
println("E_an              =   $(2 / beta);");
