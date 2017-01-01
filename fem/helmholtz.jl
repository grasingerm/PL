# do some shit with the Helmholtz equation

include("element.jl");
include("boundary.jl");

function Ke(xs::Matrix{Float64}, δ::Real)
  global pa;
  K = Matrix{Float64}(4, 4);
  for j=1:4, i=1:4
    K[i, j] = quad_2p2d((ξ, η) -> begin
      ∇Ni = [B[1, i](ξ, η); B[2, i](ξ, η)];
      ∇Nj = [B[1, j](ξ, η); B[2, j](ξ, η)];
      Je = J(xs, ξ, η);
      @assert(abs(Je - 1.0 / (pa["nx"] * pa["ny"] * 4.0)) < 1e-12, "poop");
      @assert(Je > 0.0, "Jacobian determinant must be positive");
      return (-dot(∇Ni, ∇Nj) - N[i](ξ, η)*N[j](ξ, η) / δ) * J(xs, ξ, η);
    end)
  end
  return K;
end

function fe(xs::Matrix{Float64})
  return map(i -> begin
    return quad_2p2d((ξ, η) -> begin
        Je = J(xs, ξ, η);
        @assert(Je > 0.0, "Jacobian determinant must be positive");
        return N[i](ξ, η) * Je;
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
end

pa = parse_args(s);

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

if (pa["print"])
  println("After implementing BCs\n");
  println("K = \n", K, '\n');
  println("f = \n", f, '\n');
  println("u = \n", u, '\n');
end

if (pa["plot"] || pa["plot-file"] != nothing)
  surf(vec(gcoords[1, :]), vec(gcoords[2, :]), u);
  if (pa["plot"])
    show();
  end
  if (pa["plot-file"] != nothing)
    savefig(pa["plot-file"]);
  end
end
