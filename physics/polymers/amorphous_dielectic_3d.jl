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
    argu_type = Float64
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
  n = (anti_align) ? [-1.0; 0.0; 0.0] : [1.0; 0.0; 0.0];
elseif k2 > k1
  n = [0.0; cos[phi]; sin[phi]];
else
  error("k1 cannot equal k2. Susceptibility is ill-defined."); 
end
S = [0 n[3] -n[2]; -n[3] 0 n[1]; n[2] -n[1] 0];
@assert(norm(S - S', Inf) < 1e-10);

const E0 = [pa["E0"]; 0.0; 0.0];
const p0 = (k1 > k2) k1 * E0 : k2 * E0;
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

xsum = zeros(5);
xsqsum = zeros(5);
pmagsum = 0.;
esum = 0.;
counter = 0;
nsamples = 0;

x0 = vcat(p0, n0);
u0 = potential(x0, inv_chi, E0);
u = u0;
x = copy(x0);

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
  utrial = potential(xtrial, inv_chi, E0);
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
    esum += u;
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
pdf0 = exp(-beta*u0);
Zprop = 1 / px0;
Z = pdf0 * Zprop;
println("<x>      =   $(exp_x)");
println("<x^2>    =   $(exp_xsq)");
println("<|p|^2>  =   $(pmagsum / nsamples)");
println("Δx       =   $(sqrt(exp_xsq - map(x -> x*x, exp_x)))");
println("<E>      =   $(esum / nsamples)");
println("Z     prop   $Zprop");
println("u0       =   $u0");
println("exp(-β*U0) = $pdf0");
println("Z        =   $Z");

cphi = cos(n0[1]);
sphi = sin(n0[1]);
ctheta = cos(n0[2]);
stheta = sin(n0[2]);
n = [cphi * stheta; sphi * stheta; ctheta];
A = (1/k1 - 1/k2)*(eye(3)*dot(n, p0) + n*p0');
K = vcat(hcat(inv_chi(n), A), hcat(A', (1/k1-1/k2)*p0*p0'));
@assert(size(K) == (6, 6));
lambdas = eigvals(K);
plambda = 1.0;
Z_an = 1.0;
for lambda in lambdas
  @assert(lambda > -1e-8, "negative eigenvalue: $lambda");
  if abs(lambda) > 1e-8
    plambda *= lambda;
    Z_an *= sqrt(2 * π / (beta * lambda));
  end
end
println("Πλ        =   $plambda");
println("Πλ (alg)  =   $(norm(E0, 2)^2 * (k2 - k1) / (k1 * k2^2))");
println("Z_an      =   $Z_an");
println("ratio     =   $(Z / Z_an)");
