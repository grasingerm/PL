using ArgParse;
using PyPlot;

s = ArgParseSettings();
@add_arg_table s begin
  "--dx", "-l"
    help = "Discretization parameter"
    arg_type = Float64
    default = 1.0
  "--length", "-L"
    help = "Length of the beam"
    arg_type = Float64
    default = 1.0
  "--youngs", "-E"
    help = "Young's modulus"
    arg_type = Float64
    default = 1.0
  "--Poisson", "-V"
    help = "Poisson's ratio"
    arg_type = Float64
    default = 0.3
  "--section-shape", "-S"
    help = "Shape of the beam cross-section (circle | square)"
    arg_type = String
    default = "circle"
  "--depth", "-D"
    help = "Depth of the beam cross-section"
    arg_type = Float64
    default = 1.0
  "--dist-load", "-q"
    help = "Distributed load"
    arg_type = Float64
    default = 1.0
  "--plot", "-p"
    help = "Plot solution"
    action = :store_true
  "--plot-file", "-f"
    help = "Plot filename"
    arg_type = String
  "--print", "-v"
    help = "Print K, f, and u"
    action = :store_true
  "--test-int-funcs", "-t"
    help = "Test interpolation functions"
    action = :store_true
  "--plot-int-funcs", "-P"
    help = "Plot interpolation functions"
    action = :store_true
  "--cantilever", "-C"
    help = "Fixed at x = 0"
    action = :store_true
end

pa = parse_args(s);

const l = pa["dx"];
const L = pa["length"];
const E = pa["youngs"];
const ν = pa["Poisson"];
const G = E / (2*(1+ν));
const d = pa["depth"];

I, kz, area = if pa["section-shape"] == "circle"
                pi * d^4 / 4, 6/7, pi*d^2/4;
              elseif pa["section-shape"] == "square"
                d^4 / 12, 5/6, d*d;
              else
                warn("Do not understand shape: " * pa["section-shape"]);
                exit();
                1.0; # so that type-deduction knows this should always be a float
              end

const q = pa["dist-load"];
const fe = q * l / 12 * [6; -l; 6; l];

# Euler-Bernolli
N1(x) = 1 - 3 * (x / l)^2 + 2 * (x / l)^3;
N3(x) = 3 * (x / l)^2 - 2 * (x / l)^3;

N2(x) = -x * (1 - x / l)^2
N4(x) = -x * ((x / l)^2 - x / l);

dN1dx(x) = -6 * (x / l^2) * (1 - x / l);
dN3dx(x) = 6 * (x / l^2) * (1 - x / l);

dN2dx(x) = -(1 + 3*(x/l)^2 - 4*(x/l));
dN4dx(x) = - x / l * (3*x/l - 2);

d2N1dx2(x) = -6 / l^2 * (1 - 2 * x / l);
d2N3dx2(x) = 6 / l^2 * (1 - 2 * x / l);

d2N2dx2(x) = -2 / l * (3 * x / l - 2);
d2N4dx2(x) = -2 / l * (3 * x / l - 1);

const Ke = 2 * E * I / l^3 * [ 6     -3*l      -6        -3*l;
                              -3*l    2*l^2     3*l         l^2;
                              -6      3*l       6         3*l;
                              -3*l      l^2     3*l       2*l^2  ];
@assert(norm(Ke-Ke', 2) < 1e-9);

# integration
const _GP2_ = [-1/sqrt(3); 1/sqrt(3)];
const _GW2_ = [1.0; 1.0];
function gauss1D2P(f::Function)
  res = 0.0;
  for i=1:length(_GP2_)
    res += _GW2_[i] * f(_GP2_[i]);
  end
  return res;
end

const _GP3_ = [-sqrt(3/5); 0; sqrt(3/5)];
const _GW3_ = [5/9; 8/9; 5/9];
function gauss1D3P(f::Function)
  res = 0.0;
  for i=1:length(_GP3_)
    res += _GW3_[i] * f(_GP3_[i]);
  end
  return res;
end

@assert(abs(gauss1D2P(x -> x) < 1e-7));
@assert(abs(gauss1D2P(x -> 1) - 2 < 1e-7));
@assert(abs(gauss1D2P(x -> x^2) - 2/3 < 1e-7));
@assert(abs(gauss1D3P(x -> x)) < 1e-7);
@assert(abs(gauss1D3P(x -> 1) - 2) < 1e-7);
@assert(abs(gauss1D3P(x -> x^2) - 2/3) < 1e-7);
@assert(abs(gauss1D3P(x -> x^3) - 0) < 1e-7);
@assert(abs(gauss1D3P(x -> x^4) - 2/5) < 1e-7);

# Timoshenko
Nt1(ξ::Real) = 1/2*ξ*(1 - ξ); 
Nt2(ξ::Real) = (1 - ξ^2);
Nt3(ξ::Real) = 1/2*ξ*(ξ + 1);
Btb(ξ::Real) = 2/l*[0; ξ-1/2; 0; -2*ξ; 0; ξ+1/2];
Bts(ξ::Real) = 2/l*[ξ-1/2; -l/4*(ξ^2-ξ); -2*ξ; -l/2*(1-ξ^2); ξ+1/2; -l/4*(ξ^2+ξ)];

const Db = E*I;
const Ds = kz*G*area;
const Kb = (Db / (3*l)) * (Float64[0 0 0 0 0 0;
                                   0 7 0 -8 0 1;
                                   0 0 0 0 0 0;
                                   0 -8 0 16 0 -8;
                                   0 0 0 0 0 0;
                                   0 1 0 -8 0 7]);

#=const Ks = (Ds / (9*l)) * (Float64[21       -9*l/2      -24       -6*l      3         3*l/2;
                                   -9*l/2    l^2         6*l       l^2     -3*l/2      -l^2/2;
                                   -24      6*l         48        0       -24         -6*l;
                                   -6*l     l^2         0         4*l^2     6*l       l^2;
                                   3        -3*l/2      -24       6*l       21        9*l/2;
                                   3*l/2    -l^2/2      -6*l      l^2       9*l/2     l^2]);=#
const Ks = (Ds / (9*l)) * (Float64[21       9*l/2      -24       6*l      3         3*l/2;
                                   9*l/2    l^2         6*l       l^2     -3*l/2      -l^2/2;
                                   -24      6*l         48        0       -24         -6*l;
                                   6*l     l^2         0         4*l^2     6*l       l^2;
                                   3        -3*l/2      -24       6*l       21        9*l/2;
                                   3*l/2    -l^2/2      -6*l      l^2       9*l/2     l^2]);
@assert(norm(Ks-Ks',Inf) < 1e-9);

KsTest = zeros(6, 6);
KsRI = zeros(6, 6);
for j=1:6, k=1:6
  KsRI[j, k] = Ds*l/2 * gauss1D2P(ξ -> (Bts(ξ)[j])*(Bts(ξ)[k]));
  KsTest[j, k] = Ds*l/2 * gauss1D3P(ξ -> (Bts(ξ)[j])*(Bts(ξ)[k]));
end
@show KsTest, Ks;
for j=1:6, k=1:6
  @show j, k, Ks[j, k], KsTest[j, k];
  @assert(abs(Ks[j, k] - KsTest[j, k]) < 1e-6);
end
exit();

const Ket = Kb + Ks;
const KetRI = Kb + KsRI;
@assert(norm(Ket-Ket', 2) < 1e-9);
@assert(norm(KetRI-KetRI', 2) < 1e-9);
const fet = l/2 * [q; 0; q; 0];

@assert(L / l == round(L / l), "dx, $l, must go into the length, $L, evenly");
# EB mesh
const nnodes = convert(Int, L / l + 1);
const ndofs = nnodes * 2;
const nelems = nnodes - 1;
gcoords = map(i -> l * i, 0:nnodes-1);
gdofs = Matrix{Int}(4, nelems);

# 3-node element mesh
const nndoes2 = nelems*2 + 1;
const ndofs2 = nnodes2 * 2;
gcoords2 = map(i -> l * i, 0:nnodes2-1);
gdofs2 = Matrix{Int}(6, nelems);

for i=1:nelems
  gdofs[1, i] = 2 * i - 1;
  gdofs[2, i] = 2 * i;
  gdofs[3, i] = 2 * i + 1;
  gdofs[4, i] = 2 * i + 2;
  
  gdofs2[1, i] = 4 * i - 3;
  gdofs2[2, i] = 4 * i - 2;
  gdofs2[3, i] = 4 * i - 1;
  gdofs2[4, i] = 4 * i + 0;
  gdofs2[5, i] = 4 * i + 1;
  gdofs2[6, i] = 4 * i + 2;
end

K = zeros(ndofs, ndofs);
K1 = zeros(ndofs, ndofs);
KRI = zeros(ndofs, ndofs);
f = zeros(ndofs);
f1 = zeros(ndofs);
fRI = zeros(ndofs);
for elidx=1:nelems
  egdofs = view(gdofs, :, elidx);
  for i=1:4, j=1:4
    K[egdofs[i], egdofs[j]] += Ke[i, j];
    K1[egdofs[i], egdofs[j]] += Ket[i, j];
    KRI[egdofs[i], egdofs[j]] += KetRI[i, j];
  end
  for i=1:4
    f[egdofs[i]] += fe[i];
    f1[egdofs[i]] += fet[i];
    fRI[egdofs[i]] += fet[i];
  end
end

@assert(K == K', "K must be symmetric");
@assert(K1 == K1', "K must be symmetric");
@assert(KRI == KRI', "K must be symmetric");

if pa["print"]
  println("Before enforcing BCs");
  println("K = \n$K");
  println("f = \n$f");
end

#enforce BCs
bcs = (pa["cantilever"]) ? [(1, 0.0), (2, 0.0)] : [(1, 0.0), (ndofs-1, 0.0)];

for bc in bcs
  k, g = bc
  for i = 1:ndofs
    if k == i
      continue;
    else
      f[i] -= K[i, k] * g;
      K[i, k] = 0.0;
      K[k, i] = 0.0;
      
      f1[i] -= K1[i, k] * g;
      K1[i, k] = 0.0;
      K1[k, i] = 0.0;
      
      fRI[i] -= KRI[i, k] * g;
      KRI[i, k] = 0.0;
      KRI[k, i] = 0.0;
    end
    f[k] = g;
    K[k, k] = 1.0;
    
    f1[k] = g;
    K1[k, k] = 1.0;
    
    fRI[k] = g;
    KRI[k, k] = 1.0;
  end
end

u = K \ f;
u1 = K1 \ f1;
uRI = KRI \ fRI;

if pa["print"]
  println("K = \n$K");
  println("f = \n$f");
  println("u = \n$u");
end

const w = map(i -> -u[2*i - 1], 1:nnodes);
const θ = map(i -> -u[2*i], 1:nnodes);
const w1 = map(i -> -u1[2*i - 1], 1:nnodes);
const θ1 = map(i -> u1[2*i], 1:nnodes);
const wRI = map(i -> -uRI[2*i - 1], 1:nnodes);
const θRI = map(i -> uRI[2*i], 1:nnodes);

cw    = (x -> q * x^2 / (24 * E * I ) * (x^2 + 6 * L^2 - 4 * L * x),
         x -> q*x/(6*E*I) * (3*L^2 - 3*L*x + x^2));

sw    = (x -> q * x / (24 * E * I) * (L^3 - 2 * L * x^2 + x^3),
         x -> q*x^3 / (6*E*I) - q*L*x^2 / (4*E*I) + q*L^3 / (24*E*I));

#compute error
w_soln, θ_soln = if pa["cantilever"]
  cw;
else
  sw;
end

ax = linspace(0.0, L, 1000);
aw = -map(w_soln, ax);
aθ = map(θ_soln, ax);

println("Numerical error at nodes (EB):");
println("relative L2(w) = $(norm(-map(w_soln, gcoords) - w, 2) / norm(map(w_soln, gcoords), 2))");
println("relative L2(θ) = $(norm(map(θ_soln, gcoords) - θ, 2) / norm(map(θ_soln, gcoords), 2))");

println()
println("Numerical error at nodes (Timoshenko):");
println("relative L2(w) = $(norm(-map(w_soln, gcoords) - w1, 2) / norm(map(w_soln, gcoords), 2))");
println("relative L2(θ) = $(norm(map(θ_soln, gcoords) - θ1, 2) / norm(map(θ_soln, gcoords), 2))");

println()
println("Numerical error at nodes (Timoshenko RI):");
println("relative L2(w) = $(norm(-map(w_soln, gcoords) - wRI, 2) / norm(map(w_soln, gcoords), 2))");
println("relative L2(θ) = $(norm(map(θ_soln, gcoords) - θRI, 2) / norm(map(θ_soln, gcoords), 2))");

if pa["plot"]
  subplot(2, 1, 1);
  plot(ax, aw, "-", gcoords, w, "x", gcoords, w1, "o", gcoords, wRI, "<");
  title("deflected shape");
  legend(["analytical", "EB", "Timo.", "TRI"]);
  subplot(2, 1, 2);
  plot(ax, aθ, "-", gcoords, θ, "x", gcoords, θ1, "o", gcoords, θRI, "<");
  title("slope");
  legend(["analytical", "EB", "Timo.", "TRI"]);
  show();
end
