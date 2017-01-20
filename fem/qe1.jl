# define interpolation functions
N1(ξ::Real, η::Real) = 0.25 * (1.0 - ξ) * (1.0 - η);
N2(ξ::Real, η::Real) = 0.25 * (1.0 + ξ) * (1.0 - η);
N3(ξ::Real, η::Real) = 0.25 * (1.0 + ξ) * (1.0 + η);
N4(ξ::Real, η::Real) = 0.25 * (1.0 - ξ) * (1.0 + η);

N = [N1; N2; N3; N4];

N1ξ(ξ::Real, η::Real) = -0.25 * (1.0 - η);
N2ξ(ξ::Real, η::Real) =  0.25 * (1.0 - η);
N3ξ(ξ::Real, η::Real) =  0.25 * (1.0 + η);
N4ξ(ξ::Real, η::Real) = -0.25 * (1.0 + η);

N1η(ξ::Real, η::Real) = -0.25 * (1.0 - ξ);
N2η(ξ::Real, η::Real) = -0.25 * (1.0 + ξ);
N3η(ξ::Real, η::Real) =  0.25 * (1.0 + ξ);
N4η(ξ::Real, η::Real) =  0.25 * (1.0 - ξ);

B = [N1ξ N2ξ N3ξ N4ξ;
     N1η N2η N3η N4η];

# Points for Gaussian quadrature
_GP = [-sqrt(1.0 / 3.0); sqrt(1.0 / 3.0)];
_GW = [1.0; 1.0];

# Integration by Gaussian quadrature
_GP = Vector{Float64}[
  [0.0],
  [-sqrt(1.0 / 3.0); sqrt(1.0 / 3.0)],
  [-sqrt(3.0 / 5.0); 0.0; sqrt(3.0 / 5.0)]
];

_GW = Vector{Float64}[
  [2.0],
  [1.0; 1.0],
  [5.0 / 9.0; 8.0 / 9.0; 5.0 / 9.0]
];

function quad_1p2d(f::Function)
  return _GW[1][1] * _GW[1][1] * f(_GP[1][1], _GP[1][1]);
end

function quad_2p2d(f::Function)
  sum = 0.0;
  for i=1:2, j=1:2
    sum += _GW[2][i] * _GW[2][j] * f(_GP[2][i], _GP[2][j]);
  end
  return sum;
end

function quad_3p2d(f::Function)
  sum = 0.0;
  for i=1:3, j=1:3
    sum += _GW[3][i] * _GW[3][j] * f(_GP[3][i], _GP[3][j]);
  end
  return sum;
end

# Calculate Jacobian matrix
function J(xs::Matrix{Float64}, ξ::Real, η::Real)
  const N_ = [
              N1ξ(ξ, η) N2ξ(ξ, η) N3ξ(ξ, η) N4ξ(ξ, η); 
              N1η(ξ, η) N2η(ξ, η) N3η(ξ, η) N4η(ξ, η)
             ];
  return N_ * xs;
end

# Element stiffness matrix
function Kes(xs::Matrix{Float64})
  K1 = Matrix{Float64}(4, 4);
  for j=1:4, i=1:4
    K1[i, j] = quad_2p2d((ξ, η) -> begin
      ∇Ni = [B[1, i](ξ, η); B[2, i](ξ, η)];
      ∇Nj = [B[1, j](ξ, η); B[2, j](ξ, η)];
      const Je = J(xs, ξ, η);
      const Ji = inv(Je);
      const detJe = det(Je);
      @assert(detJe > 0.0, "Jacobian determinant must be positive");
      return dot(Ji * ∇Ni, Ji * ∇Nj) + π^2 * N[i](ξ, η)*N[j](ξ, η) * detJe;
    end)
  end
  K2 = Matrix{Float64}(4, 4);
  for j=1:4, i=1:4
    K2[i, j] = quad_2p2d((ξ, η) -> begin
      const Je = J(xs, ξ, η);
      const Ji = inv(Je);
      const detJe = det(Je);
      @assert(detJe > 0.0, "Jacobian determinant must be positive");
      return  * detJe;
    end)
  end
  return K1, K2;
end

# Map parent element coordinates to spatial coordinates
function xy(xs::Matrix{Float64}, ξ::Real, η::Real)
  return [N[1](ξ, η) N[2](ξ, η) N[3](ξ, η) N[4](ξ, η)]*xs; 
end

function fes(xs::Matrix{Float64})
  fe1 = map(i -> begin
    return quad_2p2d((ξ, η) -> begin
        xye = xy(xs, ξ, η);
        x = xye[1];
        y = xye[2];
        detJe = det(J(xs, ξ, η));
        @assert(detJe > 0.0, "Jacobian determinant must be positive");
        return N[i](ξ, η) * y * detJe
      end);
    end, 1:4);
  fe2 = map(i -> begin
    return quad_3p2d((ξ, η) -> begin
        xye = xy(xs, ξ, η);
        x = xye[1];
        y = xye[2];
        detJe = det(J(xs, ξ, η));
        @assert(detJe > 0.0, "Jacobian determinant must be positive");
        return -4 / 9 * N[i](ξ, η) * x^2 * y * detJe
      end);
    end, 1:4);
  return fe1, fe2;
end

Ks = zeros(6, 6), zeros(6, 6);
fs = zeros(6), zeros(6);
xs = [-1.5 0.0; 0.0 0.0; 0.0 5.0; -1.0 5.0];
Kes_ = Kes(xs);
fes_ = fes(xs);

# Assembly
gdofs = [1 2 5 6; 3 2 5 4];
for k=1:2
  egdofs = vec(gdofs[k, :]);
  for j=1:4, i=1:4
    Ks[1][egdofs[i], egdofs[j]] += Kes_[1][i, j];
    Ks[2][egdofs[i], egdofs[j]] += Kes_[2][i, j];
  end
  for i=1:4
    fs[1][egdofs[i]] += fes_[1][i];
    fs[2][egdofs[i]] += fes_[2][i];
  end
end

println("K1 = \n$(Ks[1])");
println("K2 = \n$(Ks[2])");
println("f1 = \n$(fs[1])");
println("f2 = \n$(fs[2])");
println();
K = Ks[1] + Ks[2];
f = fs[1] + fs[2];
@show det(K);
println("K = \n$(K)");
println("f = \n$(f)");

println()
u = K \ f;
println("u = \n$u");
