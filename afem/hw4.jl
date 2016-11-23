const Ey = 100.0;
const ν = 0.45;
const Eystar = Ey / (1 - ν^2);
const νstar = ν / (1 - ν);
const C_SE = Eystar / (1 - νstar^2) * Float64[1.0 νstar 0.0; νstar 1.0 0.0; 0.0 0.0 (1 - νstar) / 2.0];

function S(E::Matrix{Float64})
  return C_SE * E;
end

function N(ξ::Real, η::Real)
  return [N1(ξ, η) 0.0 N2(ξ, η) 0.0 N3(ξ, η) 0.0 N4(ξ, η) 0.0;
          0.0 N1(ξ, η) 0.0 N2(ξ, η) 0.0 N3(ξ, η) 0.0 N4(ξ, η)];
end

function B(ξ::Real, η::Real)
  return [B11(ξ, η) 0.0 B21(ξ, η) 0.0 B31(ξ, η) 0.0 B41(ξ, η) 0.0;
          0.0 B12(ξ, η) 0.0 B22(ξ, η) 0.0 B32(ξ, η) 0.0 B42(ξ, η);
          B11(ξ, η) B12(ξ, η) B21(ξ, η) B22(ξ, η) B31(ξ, η) B32(ξ, η) B41(ξ, η) B42(ξ, η)];
end

const δλ = 0.1;
const τ = Float64[1000.0; 500.0];
const X = [0.0 5.0 5.0 0.0; 0.0 2.0 5.0 8.0]; # each column is a position is ref configuration, i.e. X1 = X[:, 1]

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
println();

println("Initial guess...");
println("=========================");
println("u0    = \n", u0);
println();

for λ = 0.0:δλ:1.0
  println("Loading step... λ = ", λ);
end
