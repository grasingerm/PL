using Optim
using BlackBoxOptim

include("PhysicalConstants.jl");
using PhysicalConstants;
_pc = PhysicalConstants;

macro test_and_print(x, y)
  return quote
    println($x, " =? ", $y);
    @assert(norm($x - $y, Inf) / ((norm($x, Inf) != 0.0) ? norm($x, Inf) : 1.0) 
            < 1e-6);
  end
end

function electrical_field_dipole(p::Vector{Float64}, r::Vector{Float64})
  const r2 = dot(r, r);
  const modr = sqrt(r2);
  const r3 = r2 * modr;

  #return (3.0 * dot(p, r) * r / r2 - p) / (4 * pi * _pc.ϵ0 * r3);
  return (3.0 * dot(p, r) * r / r2 - p) / (4 * pi * r3);
end

function dipole_kernel(r::Vector{Float64})
  const r2 = dot(r, r);
  const modr = sqrt(r2);
  const r3 = r2 * modr;

  const D = length(r);

  #return (3.0 * (r * r') / r2 - eye(D)) / (4 * pi * _pc.ϵ0 * r3);
  return (3.0 * (r * r') / r2 - eye(D)) / (4 * pi * r3);
end

r12 = [2.0; 0.0];
p1 = [1.2; 1.2];
p2 = [-0.1; 1.0];

@test_and_print(electrical_field_dipole(p1, r12), dipole_kernel(r12) * p1);
@test_and_print(electrical_field_dipole(p1, -r12), dipole_kernel(-r12) * p1);

for i = 1:5
  rij = rand(3);
  p = rand(3);
  @test_and_print(electrical_field_dipole(p, rij), dipole_kernel(rij) * p);
end

for i = 1:25
  rij = rand(3);
  c = rand(-1e3:0.1:1e3);
  kij = dipole_kernel(c * rij);
  println("Pos. def.? => $(isposdef(kij)); symm ?= $(kij == kij'); ",
          "eigvals => $(eigvals(kij)), det => $(det(kij))");
end

println();
println("Is the determinant of the dipole kernel always positive?");
for i = 1:10000
  c = rand(-1e2:0.1:1e2);
  kij = dipole_kernel(c * rand(3));
  @assert(det(kij) > 0.0 || isnan(det(kij)));
  #@assert(det(dipole_kernel(rand(2))) > 0.0);
end
println("... we can be confident that it is.");

results = optimize(r -> det(dipole_kernel(r) * norm(r, 2)^3), [1.0; 1.0; 1.0]);
println("Minimumizer r: $(Optim.minimizer(results))");
println("Minimum cost: $(Optim.minimum(results))");

bboptimize(r -> det(dipole_kernel(r) * norm(r, 2)^3); SearchRange = (-5.0, 5.0), 
           NumDimensions = 3, TraceMode = :verbose);
