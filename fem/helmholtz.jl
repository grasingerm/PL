# do some shit with the Helmholtz equation

include("element.jl");

function Ke(xs::Matrix{Float64}, δ::Real)
  K = Matrix{Float64}(4, 4);
  for j=1:4, i=1:4
    K[i, j] = quad_2p2d((ξ, η) -> begin
      ∇Ni = [B[1, i](ξ, η); B[2, i](ξ, η)];
      ∇Nj = [B[1, j](ξ, η); B[2, j](ξ, η)];
      return dot(∇Ni, ∇Nj) - N[i](ξ, η)*N[j](ξ, η) / δ * J(ξ, η);
    end)
  end
  return K;
end

function fe(xs::Matrix{Float64})
  return pmap(i -> begin
    return quad_2p2d((ξ, η) -> N[i](ξ, η) * J(ξ, η));
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
  "--ny", "-x"
    help = "Number of elements in the y-direction"
    arg_type = Int
    default = 5
  "--delta", "-d"
    help = "Material parameter"
    arg_type = Real
    default = 0.01
end

pa = parse_args(s);

gdofs, gcoords = mesh_rectangle(0.0, 1.0, 0.0, 1.0, pa["nx"], pa["ny"]);
const nelems = size(gdofs, 2);
const nnodes = size(gcoords, 2);

K = zeros(nnodes, nnodes);
f = zeros(nnodes);

# assemble global K and global f
for elem=1:nelem
  const Ke_ = Ke(xs, pa["delta"]);
  const fe_ = fe(xs);

  egdofs = view(gdofs, :, elem)
  for j=1:4, i=1:4
    K[egdofs[i], egdofs[j]] += Ke_[i, j];
  end

  for i=1:4
    f[egdofs[i]] += f[i];
  end
end

#implement boundary conditions

u = K \ f;
