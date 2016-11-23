const Ey = 100.0;
const ν = 0.45;
const Eystar = Ey / (1 - ν^2);
const νstar = ν / (1 - ν);
const C_SE = Eystar / (1 - νstar^2) * Float64[1.0 νstar 0.0; νstar 1.0 0.0; 0.0 0.0 (1 - νstar) / 2.0];

function S(E::Matrix{Float64})
  return C_SE * E;
end

const GP = 1.0 / sqrt(3) * [-1.0; 1.0];
const GW = [1.0; 1.0];

N1(ξ, η) = 0.25 * (1.0 - ξ) * (1.0 - η);
N2(ξ, η) = 0.25 * (1.0 + ξ) * (1.0 - η);
N3(ξ, η) = 0.25 * (1.0 + ξ) * (1.0 + η);
N4(ξ, η) = 0.25 * (1.0 - ξ) * (1.0 + η);

B11(ξ, η) = -0.25 * (1.0 - η);
B21(ξ, η) = 0.25 * (1.0 - η);
B31(ξ, η) = 0.25 * (1.0 + η);
B41(ξ, η) = -0.25 * (1.0 + η);
B12(ξ, η) = -0.25 * (1.0 - ξ);
B22(ξ, η) = -0.25 * (1.0 + ξ);
B32(ξ, η) = 0.25 * (1.0 + ξ);
B42(ξ, η) = 0.25 * (1.0 - ξ);

const N_ = [N1; N2; N3; N4];
const B_ = [B11 B21 B31 B41;
            B12 B22 B32 B42];

function N(ξ::Real, η::Real)
  return [N1(ξ, η) 0.0 N2(ξ, η) 0.0 N3(ξ, η) 0.0 N4(ξ, η) 0.0;
          0.0 N1(ξ, η) 0.0 N2(ξ, η) 0.0 N3(ξ, η) 0.0 N4(ξ, η)];
end

function B(ξ::Real, η::Real)
  return [B11(ξ, η) 0.0 B21(ξ, η) 0.0 B31(ξ, η) 0.0 B41(ξ, η) 0.0;
          0.0 B12(ξ, η) 0.0 B22(ξ, η) 0.0 B32(ξ, η) 0.0 B42(ξ, η);
          B11(ξ, η) B12(ξ, η) B21(ξ, η) B22(ξ, η) B31(ξ, η) B32(ξ, η) B41(ξ, η) B42(ξ, η)];
end

function Fξ(ξ::Real, η::Real, y::Matrix{Float64})
  retval = zeros(2, 2);
  for j=1:2, i=1:2, k=1:4
    retval[i, j] += B_[j, k](ξ, η) * y[i, k];
  end
  return retval;
end

function J(ξ::Real, η::Real, y::Matrix{Float64})
  return det(Fξ(ξ, η, y));
end

# [N1,y1 N2,y1 N3,y1 N4,y1; N1,y2 N2,y2 N3,y2 N4,y2]
function ∇N(ξ::Real, η::Real, y::Matrix{Float64})
  FyiT = (inv(Fξ(ξ, η, y)))';
  return FyiT * [B11(ξ, η) B21(ξ, η) B31(ξ, η) B41(ξ, η);
                 B12(ξ, η) B22(ξ, η) B32(ξ, η) B42(ξ, η)];
end

function ∇u(ξ::Real, η::Real, y::Matrix{Float64}, u::Vector{Float64})
  return u * (∇N(ξ, η, y))';
end

function E(ξ::Real, η::Real, X::Matrix{Float64}, u::Vector{Float64})
  F_ = ∇u(ξ, η, X, u) + eye(2, 2);
  return 0.5 * (F_' * F_ - eye(2, 2));
end

function B0(ξ::Real, η::Real, X::Matrix{Float64}, u::Vector{Float64})
  ∇N_ = ∇N(ξ, η, X);
  F_ = u * (∇N_') + eye(2, 2);
  B0s = map(k -> begin
        ([F_[1, 1]*∇N_[1, k] F_[2, 1]*∇N_[1, k];
          F_[1, 2]*∇N_[2, k] F_[2, 2]*∇N_[2, k];
          F_[1, 1]*∇N_[2, k]+F_[1, 2]*∇N_[1, k] F_[2, 2]*∇N_[1, k]+F_[2, 1]*∇N_[2, k]])
        end, 1:4);
  return hcat(B0s...); 
end

function I(X::Matrix{Float64}, u::Vector{Float64})
  return gauss_quad((ξ::Real, η::Real) -> (B0(ξ, η, X, u))' * S(E(ξ, η, X, u)) * J(ξ, η, X));
end

const τ = Float64[0.0 0.0; 1000.0 500.0; 0.0 0.0; 0.0 0.0]';
const edge_idxs = [1 2; 2 3; 3 4; 4 1]';
const edge_gps1 = [GP[1] -1.0; 1.0 GP[1]; GP[1] 1.0; -1.0 GP[1]]';
const edge_gps2 = [GP[2] -1.0; 1.0 GP[2]; GP[2] 1.0; -1.0 GP[2]]';
const edge_normals = [0.0 -1.0; 1.0 0.0; 0.0 1.0; -1.0 0.0]';

function P(X::Matrix{Float64})
  p = zeros(8, 1);
  for k=1:4 
    edge_idx = sub(edge_idxs, :, k);
    edge_gp1 = sub(edge_gps1, :, k);
    edge_gp2 = sub(edge_gps2, :, k);
    τk = sub(τ, :, k);
    edge_normal = sub(edge_normals, :, k);

    F1 = Fξ(edge_gp1[1], edge_gp1[2], X);
    J1A = det(F1) * norm(inv(F1)' * edge_normal, 2);

    F2 = Fξ(edge_gp2[1], edge_gp2[2], X);
    J2A = det(F2) * norm(inv(F2)' * edge_normal, 2);

    p[2*edge_idx[1]-1] += (N_[edge_idx[1]](edge_gp1...) * J1A + 
                           N_[edge_idx[1]](edge_gp2...) * J2A) * τk[1];
    p[2*edge_idx[1]]   += (N_[edge_idx[1]](edge_gp1...) * J1A + 
                           N_[edge_idx[1]](edge_gp2...) * J2A) * τk[2];
    p[2*edge_idx[2]-1] += (N_[edge_idx[2]](edge_gp1...) * J1A + 
                           N_[edge_idx[2]](edge_gp2...) * J2A) * τk[1];
    p[2*edge_idx[2]]   += (N_[edge_idx[2]](edge_gp1...) * J1A + 
                           N_[edge_idx[2]](edge_gp2...) * J2A) * τk[2];
  end
  return p
end

function Kmat(X::Matrix{Float64}, u::Vector{Float64})
  integrand = 0.0;
  for i=1:2, j=1:2
    ξ = GP[i];
    η = GP[j];
    B0_ = B0(ξ, η, X, u);
    integrand += B0_' * C_SE * B0_ * GW[i] * GW[j];
  end
  return integrand;
end

function Bgeom(ξ::Real, η::Real, X::Matrix{Float64})
  ∇N_ = ∇N(ξ, η, X);
  Bgeoms = map(k -> begin
               ([∇N_[1, k] 0.0;
                 ∇N_[2, k] 0.0;
                 0.0 ∇N_[1, k];
                 0.0 ∇N_[2, k];])
        end, 1:4);
  return hcat(Bgeoms...);
end

function Sbar(S_::Vector{Float64})
  SS = [S_[1] S_[3]; S_[3] S_[2]]; 
  return vcat(hcat(SS, zeros(2, 2)), hcat(zeros(2, 2), SS));
end

function Kgeom(X::Matrix{Float64}, u::Vector{Float64})
  integrand = 0.0;
  for i=1:2, j=1:2
    ξ = GP[i];
    η = GP[j];
    Bgeom_ = Bgeom(ξ, η, X);
    Sbar_ = Sbar(S(E(ξ, η, X, u)));
    integrand += Bgeom_' * Sbar_ * Bgeom_ * GW[i] * GW[j];
  end
  return integrand;
end

const δλ = 0.1;
const X0 = [0.0 5.0 5.0 0.0; 0.0 2.0 5.0 8.0]; # each column is a position is ref configuration, i.e. X1 = X[:, 1]
#const X = [-1.0 1.0 1.0 -1.0; -1.0 -1.0 1.0 1.0]; # each column is a position is ref configuration, i.e. X1 = X[:, 1]

#initialize data structures, stress or strains

#define initial guess
const ϵ_u0 = 1e-3;
const u0 = ϵ_u0 * [0.0 0.0 1.0 1.0; 0.0 0.0 0.5 0.5];

println("Program initialization...");
println("=========================");
println("Ey    = ", Ey);
println("ν     = ", ν);
println("Ey*   = ", Eystar);
println("ν*    = ", νstar);
println("C_SE  = \n", C_SE);
println("X     = \n", X);
println();

println("Loading parameters...");
println("=========================");
println("δλ    = ", δλ);
println("τ     = ", τ);
const P0 = P(X0);
println("P     = \n", P0);
println();

println("Initial guess...");
println("=========================");
println("u0    = \n", u0);
println();

const max_iter = 100;
const δ = 1e-6;
println("Newton-Raphson parameters...");
println("=========================");
println("maximum number of iterations = ", max_iter);
println("error tolerance, δ           = ", δ);
println();

for ξ = 0.0:0.1:1.0, η = 0.0:0.1:1.0
  sum = 0.0;
  for k = 1:4
    sum += N_[k](ξ, η);
  end
  @assert(abs(sum - 1.0) < 1e-9)
end

uk = u0;
for λ = 0.0:δλ:1.0
  Pext = λ*P0;
  println("Loading step... λ = ", λ);
  println("Pext              = ", Pext);
  
  R02 = norm(I(X0, uk) - Pext, 2); 
  for k = 1:max_iter
    Ik = I(X0, uk);
    Ak = Kmat(X0, uk) + Kgeom(X0, u);
    Rk = I(X0, uk) - Pext;

    ϵ = norm(Rk, 2) / R02;
    if 

    Δu = Ak \ -Rk;
  end
end
