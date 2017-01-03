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
  "--moment-of-inertia", "-I"
    help = "Moment of inertia"
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
    arg_type = AbstractString
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

if pa["test-int-funcs"]
  println("Running interpolation function tests...");

  approx_eq(a, b) = (abs(a - b) < 1e-9);
  @assert(approx_eq(N1(0), 1.0));
  @assert(approx_eq(N1(L), 0.0));
  @assert(approx_eq(N3(0), 0.0));
  @assert(approx_eq(N3(L), 1.0));
  @assert(approx_eq(-dN2dx(0), 1.0));
  @assert(approx_eq(-dN2dx(L), 0.0));
  @assert(approx_eq(-dN4dx(0), 0.0));
  @assert(approx_eq(-dN4dx(L), 1.0));

  @assert(approx_eq(N2(0), 0.0));
  @assert(approx_eq(N4(0), 0.0));
  @assert(approx_eq(N2(L), 0.0));
  @assert(approx_eq(N4(L), 0.0));

  @assert(approx_eq(dN1dx(0), 0.0));
  @assert(approx_eq(dN1dx(L), 0.0));
  @assert(approx_eq(dN3dx(0), 0.0));
  @assert(approx_eq(dN3dx(L), 0.0));

  for x in rand(0.0:1e-6:L, 1000)
    @assert(approx_eq(N1(x) + N3(x), 1.0));
  end
end

if pa["plot-int-funcs"]
  xs = linspace(0.0, L, 1000);
  plot(xs, map(N1, xs));
  title("N1");
  show();
  clf();

  plot(xs, map(N2, xs));
  title("N2");
  show();
  clf();

  plot(xs, map(N3, xs));
  title("N3");
  show();
  clf();

  plot(xs, map(N4, xs));
  title("N4");
  show();
  clf();

  plot(xs, map(dN1dx, xs));
  title("dN1dx");
  show();
  clf();

  plot(xs, map(dN2dx, xs));
  title("dN2dx");
  show();
  clf();

  plot(xs, map(dN3dx, xs));
  title("dN3dx");
  show();
  clf();

  plot(xs, map(dN4dx, xs));
  title("dN4dx");
  show();
  clf();
end

const L = pa["length"];
const E = pa["youngs"];
const I = pa["moment-of-inertia"];

const Ke = 2 * E * I / l^3 * [ 6     -3*l      -6        -3*l;
                              -3*l    2*l^2     3*l         l^2;
                              -6      3*l       6         3*l;
                              -3*l      l^2     3*l       2*l^2  ];
@assert(norm(Ke-Ke', 2) < 1e-9);
const q = pa["dist-load"];
const fe = q * l / 12 * [6; -l; 6; l];

@assert(L / l == round(L / l), "dx, $l, must go into the length, $L, evenly");
const nnodes = convert(Int, L / l + 1);
const ndofs = nnodes * 2;
const nelems = nnodes - 1;
gcoords = map(i -> l * i, 0:nnodes-1);
gdofs = Matrix{Int}(4, nelems);

for i=1:nelems
  gdofs[1, i] = 2 * i - 1;
  gdofs[2, i] = 2 * i;
  gdofs[3, i] = 2 * i + 1;
  gdofs[4, i] = 2 * i + 2;
end

K = zeros(ndofs, ndofs);
f = zeros(ndofs);
for elidx=1:nelems
  egdofs = (VERSION >= v"0.5.0") ? view(gdofs, :, elidx) : sub(gdofs, : , elidx);
  for i=1:4, j=1:4
    K[egdofs[i], egdofs[j]] += Ke[i, j];
  end
  for i=1:4
    f[egdofs[i]] += fe[i];
  end
end

@assert(K == K', "K must be symmetric");

if pa["print"]
  println("Before enforcing BCs");
  println("K = \n$K");
  println("f = \n$f");
end

#enforce BCs
bcs = (pa["cantilever"]) ? [(1, 0.0), (2, 0.0)] : [(1, 0.0), (ndofs-1, 0.0)];

for bc in bcs
  d, g = bc
  for i = 1:ndofs
    if d == i
      continue;
    else
      f[i] -= K[i, d] * g;
      K[i, d] = 0.0;
      K[d, i] = 0.0;
    end
    f[d] = g;
    K[d, d] = 1.0;
  end
end

u = K \ f;

if pa["print"]
  println("K = \n$K");
  println("f = \n$f");
  println("u = \n$u");
end

const w = map(i -> -u[2*i - 1], 1:nnodes);
const θ = map(i -> -u[2*i], 1:nnodes);

cw    = (x -> q * x^2 / (24 * E * I ) * (x^2 + 6 * L^2 - 4 * L * x),
         x -> q*L^2/2 * x - q * L * x^2 / 2 + q * x^3 / 6);

sw    = (x -> q * x / (24 * E * I) * (L^3 - 2 * L * x^2 + x^3),
         x -> q*x^3 / (6*E*I) - q*L*x^2 / (4*E*I) + q*L^3 / (24*E*I));

#compute error
w_soln, θ_soln = if pa["cantilever"]
  cw;
else
  sw;
end

aw = -map(w_soln, gcoords);
aθ = map(θ_soln, gcoords);

println("relative L2(w) = $(norm(aw - w, 2) / norm(aw, 2))");
println("relative L2(θ) = $(norm(aθ - θ, 2) / norm(aθ, 2))");

if pa["plot"]
  subplot(2, 1, 1);
  plot(gcoords, aw, "k-", gcoords, w, "kx");
  title("deflected shape");
  legend(["analytical", "FEM"]);
  subplot(2, 1, 2);
  plot(gcoords, aθ, "k-", gcoords, θ, "kx");
  title("slope");
  legend(["analytical", "FEM"]);
  show();
end
