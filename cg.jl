@show A = [2.0 4.0; 4.0 8.0];
for λ in eigvals(A)
  @assert(λ >= 0);
end

A2 = zeros(2, 2);
A2[2, :] = A[2, :];

@show x = [2.0; 0.0];
@show b = [-4.0; -8.0];
@show x0 = [2.0; -2.0];
@show A*x0, b;
@assert(norm(A*x0 - b, Inf) < 1e-10);

b2 = [0.0; b[2]];

@show r = b2 - A2*x;
@show d = r;
println("\n");

for i=1:25
  @show i;
  @show α = dot(r, r) / dot(d, A2*d);
  @show x += α * d;
  @show rp = r;
  @show r -= α*A2*d;
  if norm(r, 2) < 1e-8
    break;
  end
  @show b2 - A2*x;
  @show β = dot(r, r) / dot(rp, rp);
  @show d = r + β*[0.0; d[2]];
  println("\n");
end

A = [2.0 4.0; 4.0 8.0];
for λ in eigvals(A)
  @assert(λ >= 0);
end

A2 = zeros(2, 2);
A2[1, :] = A[1, :];

@show x = [0.0; 1.0];
@show b = [-4.0; -8.0];
@show x0 = [-4.0; 1.0];
@show A*x0, b;
@assert(norm(A*x0 - b, Inf) < 1e-10);

b2 = [b[1]; 0.0];

@show r = b2 - A2*x;
@show d = r;
println("\n");

for i=1:25
  @show i;
  @show α = dot(r, r) / dot(d, A2*d);
  @show x += α * d;
  @show rp = r;
  @show r -= α*A2*d;
  if norm(r, 2) < 1e-8
    break;
  end
  @show b2 - A2*x;
  @show β = dot(r, r) / dot(rp, rp);
  @show d = r + β*d;
  println("\n");
end

A = [1.0 1.0 -1.0; 2.0 -3.0 -2.0; -1.0 2.0 1.0];
for λ in eigvals(A)
  @assert(λ >= 0);
end

A2 = zeros(2, 2);
A2[1, :] = A[1, :];

@show x = [0.0; 1.0];
@show b = [-4.0; -8.0];
@show x0 = [-4.0; 1.0];
@show A*x0, b;
@assert(norm(A*x0 - b, Inf) < 1e-10);

b2 = [b[1]; 0.0];

@show r = b2 - A2*x;
@show d = r;
println("\n");

for i=1:25
  @show i;
  @show α = dot(r, r) / dot(d, A2*d);
  @show x += α * d;
  @show rp = r;
  @show r -= α*A2*d;
  if norm(r, 2) < 1e-8
    break;
  end
  @show b2 - A2*x;
  @show β = dot(r, r) / dot(rp, rp);
  @show d = r + β*d;
  println("\n");
end
