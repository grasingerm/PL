function potential(p::Vector{Float64}, inv_chi::Matrix{Float64}, E0::Vector{Float64})
  return 0.5 * dot(p, inv_chi * p) - dot(p, E0);
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
  "--p0_x", "-P"
    help = "x-component of initial polarization"
    arg_type = Float64
    default = 0.0
  "--p0_y", "-Q"
    help = "y-component of initial polarization"
    arg_type = Float64
    default = 0.0
  "--p0_z", "-R"
    help = "z-component of initial polarization"
    arg_type = Float64
    default = 0.0
  "--E0_x", "-E"
    help = "x-component of external electric field"
    arg_type = Float64
    default = 1.0
  "--E0_y", "-F"
    help = "y-component of external electric field"
    arg_type = Float64
    default = 1.0
  "--E0_z", "-G"
    help = "y-component of external electric field"
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
  "--Chi", "-C"
    help = "susceptibility tensor"
    arg_type = AbstractString
    default = "[1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0]"
  "--plot-histogram", "-p"
    help = "Plot histogram of positions"
    action = :store_true
  "--nbins", "-b"
    help = "Number of bins in histogram"
    arg_type = Int
    default = 50
  "--yz-slice", "-y"
    help = "Normalized y (and z) coordinate where to take the slice"
    arg_type = Float64
    default = 0.5
end

pa = parse_args(s); 

const p0 = [pa["p0_x"]; pa["p0_y"]; pa["p0_z"]];
const E0 = [pa["E0_x"]; pa["E0_y"]; pa["E0_z"]];
const beta = pa["beta"];
const nsteps = pa["num-steps"];
chi = eval(parse(pa["Chi"]));
inv_chi = inv(chi);
acc_func = eval(parse(pa["accept"]));
const delta = pa["delta"];
const dx = pa["dx"];

psum = zeros(3);
psqsum = zeros(3);
pmagsum = 0.;
esum = 0.;
counter = 0;

p = p0;
u0 = potential(p0, inv_chi, E0);
u = u0;

ps = (pa["plot-histogram"]) ? zeros(3, nsteps) : zeros(1, 1);

for step = 1:nsteps
  choice = rand(1:3);
  dp = zeros(3);
  dp[choice] += rand(-delta:1e-9:delta);
  ptrial = p + dp;
  utrial = potential(ptrial, inv_chi, E0);
  if acc_func(u, utrial, beta)
    p = ptrial;
    u = utrial;
  end
  psum += p;
  psqsum += map(x -> x*x, p);
  pmagsum += dot(p, p);
  esum += u;
  if (p[1] > p0[1] - dx && p[1] < p0[1] + dx
      && p[2] > p0[2] - dx && p[2] < p0[2] + dx
      && p[3] > p0[3] - dx && p[3] < p0[3] + dx)
    counter += 1;
  end
  if pa["plot-histogram"]
    ps[:, step] = p;
  end
end

if pa["plot-histogram"]
  p_min, p_max = map(i -> minimum(ps[i, :]), 1:3), map(i -> maximum(ps[i, :]), 1:3);
  nbins = pa["nbins"];
  dps = map(i -> (p_max[i] - p_min[i]) / (nbins - 1), 1:3);
  bins = zeros(nbins, nbins, nbins);
  for step = 1:nsteps
    i = convert(Int, div(ps[1, step] - p_min[1], dps[1])) + 1;
    j = convert(Int, div(ps[2, step] - p_min[2], dps[2])) + 1;
    k = convert(Int, div(ps[3, step] - p_min[3], dps[3])) + 1;
    bins[i, j, k] += 1;
  end
  bins /= (nsteps * dps[1] * dps[2] * dps[3]);
end


exp_p = psum / nsteps;
exp_psq = psqsum / nsteps;
px0 = counter / (nsteps * (2 * dx)^3);
Z = exp(-beta * u0) / px0;
println("<p>      =   $(exp_p)");
println("<p^2>    =   $(exp_psq)");
println("<|p|^2>  =   $(pmagsum / nsteps)");
println("Δp       =   $(sqrt(exp_psq - map(x -> x*x, exp_p)))");
println("<E>      =   $(esum / nsteps)");
#println("1/2β     =   $(1 / (2*beta))");
println("Z        =   $Z");
D, V = eig(inv_chi);
E_v = V * E0;
z_analytical = 1.0;
for i = 1:3
  z_analytical *= (sqrt(2 * pi / (beta * D[i])) * 
                   exp(beta * E_v[i]*E_v[i] / (2 * D[i])));
end
println("Z       ?=   $z_analytical");

if pa["plot-histogram"]
  islice = convert(Int, floor(pa["yz-slice"] * pa["nbins"]));
  py = dps[2] * islice + p_min[2];
  pz = dps[3] * islice + p_min[3];
  xs = p_min[1]:dps[1]:(p_max[1] + dps[1]/3.0);
  PyPlot.bar(xs, bins[:, islice, islice], dps[1]; color="cyan");
  PyPlot.plot(xs, 
              map(px -> begin
                    pslice = [px; py; pz];
                    exp(-beta * potential(pslice, inv_chi, E0)) / z_analytical;
                  end, xs),
             "k--"; linewidth=8);
  legend(["Analytical"; "MCMC"]);
  xlabel("\$p_x\$");
  ylabel("\$P(p_x)\$");
  title("Probability density of \$\\mathbf{p} = [p_x, $(@sprintf("%.2lf", py)), $(@sprintf("%.2lf", pz))]\$");
  show();
end
