# define interpolation functions
N1(xi::Real, eta::Real) = 0.25 * (1.0 - xi) * (1.0 - eta);
N2(xi::Real, eta::Real) = 0.25 * (1.0 + xi) * (1.0 - eta);
N3(xi::Real, eta::Real) = 0.25 * (1.0 + xi) * (1.0 + eta);
N4(xi::Real, eta::Real) = 0.25 * (1.0 - xi) * (1.0 + eta);

N = [N1; N2; N3; N4];

N1xi(xi::Real, eta::Real) = -0.25 * (1.0 - eta);
N2xi(xi::Real, eta::Real) =  0.25 * (1.0 - eta);
N3xi(xi::Real, eta::Real) =  0.25 * (1.0 + eta);
N4xi(xi::Real, eta::Real) = -0.25 * (1.0 + eta);

N1eta(xi::Real, eta::Real) = -0.25 * (1.0 - xi);
N2eta(xi::Real, eta::Real) = -0.25 * (1.0 + xi);
N3eta(xi::Real, eta::Real) =  0.25 * (1.0 + xi);
N4eta(xi::Real, eta::Real) =  0.25 * (1.0 - xi);

B = [N1xi N2xi N3xi N4xi;
     N1eta N2eta N3eta N4eta];

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
function J(xs::Matrix{Float64}, xi::Real, eta::Real)
  const N_ = [
              N1xi(xi, eta) N2xi(xi, eta) N3xi(xi, eta) N4xi(xi, eta); 
              N1eta(xi, eta) N2eta(xi, eta) N3eta(xi, eta) N4eta(xi, eta)
             ];
  return N_ * xs;
end

# Element stiffness matrix
function Ke(xs::Matrix{Float64})
  K1 = Matrix{Float64}(4, 4);
  for j=1:4, i=1:4
    K1[i, j] = quad_2p2d((xi, eta) -> begin
      ∇Ni = [B[1, i](xi, eta); B[2, i](xi, eta)];
      ∇Nj = [B[1, j](xi, eta); B[2, j](xi, eta)];
      const Je = J(xs, xi, eta);
      const Ji = inv(Je);
      const detJe = det(Je);
      @assert(detJe > 0.0, "Jacobian determinant must be positive");
      return (dot(Ji * ∇Ni, Ji * ∇Nj) + π^2 * N[i](xi, eta)*N[j](xi, eta)) * detJe;
    end)
  end
  return K1;
end

# Map parent element coordinates to spatial coordinates
function xy(xs::Matrix{Float64}, xi::Real, eta::Real)
  return [N[1](xi, eta) N[2](xi, eta) N[3](xi, eta) N[4](xi, eta)]*xs; 
end

function fe(xs::Matrix{Float64})
  fe1 = map(i -> begin
    return quad_2p2d((xi, eta) -> begin
        xye = xy(xs, xi, eta);
        x = xye[1];
        y = xye[2];
        detJe = det(J(xs, xi, eta));
        @assert(detJe > 0.0, "Jacobian determinant must be positive");
        return (N[i](xi, eta) * y + -4 / 9 * N[i](xi, eta) * x^2 * y)* detJe
      end);
    end, 1:4);
  return fe1;
end

K = zeros(6, 6);
f = zeros(6);
xs = [-1.5 0.0; 0.0 0.0; 0.0 5.0; -1.0 5.0];
Ke_ = Ke(xs);
fe_ = fe(xs);

# Assembly
gdofs = [1 2 5 6; 3 2 5 4];
for k=1:2
  egdofs = vec(gdofs[k, :]);
  for j=1:4, i=1:4
    K[egdofs[i], egdofs[j]] += Ke_[i, j];
  end
  for i=1:4
    f[egdofs[i]] += fe_[i];
  end
end

println("Ke = \n$(Ke)");
println("fe = \n$(fe)");
@show det(K);
println("K = \n$(K)");
println("f = \n$(f)");

println()
u = K \ f;
println("u = \n$u");
