function potential(x::Vector{Float64},
                   inv_chi::Function, E0::Vector{Float64})
  p = view(x, 1:3);
  n = view(x, 4:6);
  return 0.5 * dot(p, inv_chi(n) * p) - dot(p, E0);
end

function rotation(dtheta::Real)
  rx = [1.0 0.0 0.0; 0.0 cos(dtheta) -sin(dtheta); 0.0 sin(dtheta) cos(dtheta)];
  ry = [cos(dtheta) 0.0 sin(dtheta); 0.0 1.0 0.0; -sin(dtheta) 0.0 cos(dtheta)];
  rz = [cos(dtheta) -sin(dtheta) 0.0; sin(dtheta) cos(dtheta) 0.0; 0.0 0.0 1.0];
  return rx*ry*rz;
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
using PyPlot;

s = ArgParseSettings();
@add_arg_table s begin
  "--E0", "-E"
    help = "magnitude electric field"
    arg_type = Float64
    default = 1.5
  "--phi0", "-p"
    help = "initial monomer angle"
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
    default = 0.1
  "--k1", "-K"
    help = "first susceptibility parameter"
    arg_type = Float64
    default = 1.5
  "--k2", "-L"
    help = "second susceptibility parameter"
    arg_type = Float64
    default = 0.5
  "--write-E-surface", "-W"
    help = "Write energy surface to file"
    action = :store_true
  "--sample-frequency", "-S"
    help = "Frequency with which to sample for data file"
    arg_type = Int
    default = 25
end

pa = parse_args(s); 

const phi0 = pa["phi0"];
const n0 = [0.0; cos(phi0); sin(phi0)];
const k1 = pa["k1"];
const k2 = pa["k2"];
const E0 = [pa["E0"]; 0.0; 0.0];
const p0 = k2 * E0;
const beta = pa["beta"];
const nsteps = pa["num-steps"];
inv_chi(n) = 1/k1 * n * n' + 1/k2 * (eye(3) - n * n');
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];
const dsample = pa["sample-frequency"];
const write_datafile = pa["write-E-surface"];

xsum = zeros(6);
xsqsum = zeros(6);
pmagsum = 0.;
esum = 0.;
counter = 0;
nsamples = 0;

x0 = vcat(p0; n0);
u0 = potential(x0, inv_chi, E0);
u = u0;
x = copy(x0);

datafile = ((write_datafile) ? 
            open(joinpath("data",
                          @sprintf("energy-surface-3d_k1-%02d_k2-%02d_beta-%06d.csv",
                                   Int(round(k1*10)), Int(round(k2*10)), Int(round(beta*1000)))), "w") :
             nothing);

for step = 1:nsteps
  choice = rand(1:6);
  xtrial = copy(x);
  if choice < 4
    xtrial[choice] += rand(-delta:1e-9:delta);
  else
    xtrial[4:6] *= rotation(rand(-delta:1e-9:delta));
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
        && x[4] > x0[4] - dx && x[4] < x0[4] + dx
        && x[5] > x0[5] - dx && x[5] < x0[5] + dx
        && x[6] > x0[6] - dx && x[6] < x0[6] + dx)
      counter += 1;
    end
    if write_datafile
      for a in x
        write(datafile, "$a,");
      end
      write(datafile, "$u\n");
    end
  end
end

if write_datafile; close(datafile); end

exp_x = xsum / nsamples;
exp_xsq = xsqsum / nsamples;
px0 = counter / (nsamples * (2 * dx)^6);
Z = exp(-beta * u0) / px0;
println("<x>      =   $(exp_x)");
println("<x^2>    =   $(exp_xsq)");
println("<|p|^2>  =   $(pmagsum / nsamples)");
println("Δx       =   $(sqrt(exp_xsq - map(x -> x*x, exp_x)))");
println("<E>      =   $(esum / nsamples)");
#println("1/2β     =   $(1 / (2*beta))");
println("Z        =   $Z");
