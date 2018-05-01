# do some shit with the Helmholtz equation

include("element.jl");
include("boundary.jl");

# analytical solution
function helmholtz(gcoords::Matrix{Float64}, δ::Real; nterms::Int = 10)

  A = zeros(nterms, nterms);
  for j=1:nterms
    const m = 2*j-1;
    for i=1:nterms
      const n = 2*i-1;
      A[i, j] = 16.0 / ( (-n^2*π^2 - m^2*π^2 - 1/δ) * n*m*π^2 );
    end
  end

  const ncoords = size(gcoords, 2);
  u = zeros(ncoords);

  for k=1:ncoords

    x, y = if VERSION >= v"0.5.0"
      view(gcoords, :, k);
    else
      sub(gcoords, :, k);
    end

    for j=1:nterms
      const m = 2*j-1;
      for i=1:nterms
        const n = 2*i-1;
        u[k] += A[i, j] * sin(n*π*x) * sin(m*π*y);
      end
    end 

  end

  return u;
end

function Ke(xs::Matrix{Float64}, δ::Real)
  global pa;
  K = Matrix{Float64}(4, 4);
  for j=1:4, i=1:4
    K[i, j] = quad_2p2d((ξ, η) -> begin
      ∇Ni = [B[1, i](ξ, η); B[2, i](ξ, η)];
      ∇Nj = [B[1, j](ξ, η); B[2, j](ξ, η)];
      const Je = J(xs, ξ, η);
      const Ji = inv(Je);
      const detJe = det(Je);
      @assert(abs(detJe - 1.0 / (pa["nx"] * pa["ny"] * 4.0)) < 1e-12, "poop");
      @assert(detJe > 0.0, "Jacobian determinant must be positive");
      return (dot(Ji * ∇Ni, Ji * ∇Nj) + N[i](ξ, η)*N[j](ξ, η) / δ) * detJe;
    end)
  end
  return K;
end

function fe(xs::Matrix{Float64})
  return map(i -> begin
    return quad_2p2d((ξ, η) -> begin
        detJe = det(J(xs, ξ, η));
        @assert(detJe > 0.0, "Jacobian determinant must be positive");
        return -N[i](ξ, η) * detJe;
      end);
    end, 1:4);
end

using ArgParse;
using PyPlot;

s = ArgParseSettings();
@add_arg_table s begin
  "--nx", "-x"
    help = "Number of elements in the x-direction"
    arg_type = Int
    default = 5
  "--ny", "-y"
    help = "Number of elements in the y-direction"
    arg_type = Int
    default = 5
  "--delta", "-d"
    help = "Material parameter"
    arg_type = Float64
    default = 0.01
  "--plot", "-p"
    help = "Plot solution"
    action = :store_true
  "--plot-file", "-f"
    help = "Plot filename"
    arg_type = AbstractString
  "--print", "-t"
    help = "Print K, f, and u"
    action = :store_true
  "--test-int-funcs", "-I"
    help = "Test interpolation functions"
    action = :store_true
  "--plot-int-funcs", "-P"
    help = "Plot interpolation functions"
    action = :store_true
  "--num-terms-analyt", "-N"
    help = "Number of terms to use in the calculation of analytical solution"
    arg_type = Int
    default = 10
end

pa = parse_args(s);
const δ = pa["delta"];
const J_ = 1.0 / (pa["nx"] * pa["ny"] * 4.0);

if pa["test-int-funcs"]
  println("Running interpolation function tests...");

  approx_eq(a, b) = (abs(a - b) < 1e-9);
  @assert(approx_eq(N1(-1, -1), 1.0));
  @assert(approx_eq(N1(1, -1),  0.0));
  @assert(approx_eq(N1(1, 1),   0.0));
  @assert(approx_eq(N1(-1, 1),  0.0));

  @assert(approx_eq(N2(-1, -1), 0.0));
  @assert(approx_eq(N2(1, -1),  1.0));
  @assert(approx_eq(N2(1, 1),   0.0));
  @assert(approx_eq(N2(-1, 1),  0.0));

  @assert(approx_eq(N3(-1, -1), 0.0));
  @assert(approx_eq(N3(1, -1),  0.0));
  @assert(approx_eq(N3(1, 1),   1.0));
  @assert(approx_eq(N3(-1, 1),  0.0));

  @assert(approx_eq(N4(-1, -1), 0.0));
  @assert(approx_eq(N4(1, -1),  0.0));
  @assert(approx_eq(N4(1, 1),   0.0));
  @assert(approx_eq(N4(-1, 1),  1.0));

  for x in rand(-1.0:1e-6:1.0, 1000), y in rand(-1.0:1e-6:1.0, 1000)
    sum = 0.0;
    for i = 1:4
      sum += N[i](x, y);
    end
    @assert(approx_eq(sum, 1.0));
  end
end

if pa["plot-int-funcs"]
  xs  = zeros(100 * 100);
  ys  = zeros(100 * 100);
  n1s = zeros(100 * 100);
  n2s = zeros(100 * 100);
  n3s = zeros(100 * 100);
  n4s = zeros(100 * 100);

  idx = 1;
  for x in linspace(-1.0, 1.0, 100), y in linspace(-1.0, 1.0, 100)
    xs[idx] = x;
    ys[idx] = y;
    n1s[idx] = N1(x, y);
    n2s[idx] = N2(x, y);
    n3s[idx] = N3(x, y);
    n4s[idx] = N4(x, y);
    idx += 1;
  end

  surf(xs, ys, n1s);
  title("N1");
  show();
  clf();

  surf(xs, ys, n2s);
  title("N2");
  show();
  clf();

  surf(xs, ys, n3s);
  title("N3");
  show();
  clf();

  surf(xs, ys, n4s);
  title("N4");
  show();
  clf();
end

gdofs, gcoords = mesh_rectangle(0.0, 1.0, 0.0, 1.0, pa["nx"], pa["ny"]);
const nelems = size(gdofs, 2);
const nnodes = size(gcoords, 2);

K = zeros(nnodes, nnodes);
f = zeros(nnodes);

# assemble global K and global f
for elem=1:nelems
  const xs = xse(gdofs, gcoords, elem);
  const Ke_ = Ke(xs, pa["delta"]);
  const fe_ = fe(xs);
  @assert(norm(Ke_ - Ke_', 2) < 1e-8);

  egdofs = (VERSION >= v"0.5.0") ? view(gdofs, :, elem) : sub(gdofs, :, elem);
  for j=1:4, i=1:4
    K[egdofs[i], egdofs[j]] += Ke_[i, j];
  end

  for i=1:4
    f[egdofs[i]] += fe_[i];
  end
end

if (pa["print"])
  println("Before implementing BCs\n");
  println("K = \n", K, '\n');
  println("f = \n", f, '\n');
end

#implement boundary conditions
bcs = [
       BC((coords) -> (coords[1] == 0.0), 0.0);
       BC((coords) -> (coords[2] == 0.0), 0.0);
       BC((coords) -> (coords[1] == 1.0), 0.0);
       BC((coords) -> (coords[2] == 1.0), 0.0);
      ];
enforce_bcs!(gdofs, gcoords, K, f, bcs);

# solve
u = K \ f;
au = helmholtz(gcoords, δ; nterms=pa["num-terms-analyt"]);

if (pa["print"])
  println("After implementing BCs\n");
  println("K = \n", K, '\n');
  println("f = \n", f, '\n');
  println("u = \n", u, '\n');
end

println("Relative L2 error: ", norm(u - au, 2) / norm(au, 2));
println("Relative L∞ error: ", norm(u - au, Inf) / norm(au, Inf));

if (pa["plot"] || pa["plot-file"] != nothing)
  surf(vec(gcoords[1, :]), vec(gcoords[2, :]), au);
  scatter(vec(gcoords[1, :]), vec(gcoords[2, :]); zs=u, marker="o", c="r", s=40);
  if (pa["plot"])
    show();
  end
  if (pa["plot-file"] != nothing)
    savefig(pa["plot-file"]);
  end
end
