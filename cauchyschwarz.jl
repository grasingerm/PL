# we can define an inner product using any linear transformation (matrix) by
# <u, v> = u'*A*v. Such a definition should satisfy the Cauchy-Schwarz inequality

macro assert_ae(x, y)
  return :(abs(($x) - ($y)) < 1e-9);
end

for k=1:100000
  n = rand(1:10);
  A = 100*rand(n, n) - 50 * ones(n, n);
  u = 100*rand(n) - 50 * ones(n);
  v = 100*rand(n) - 50 * ones(n);

  _dot(u, v) = (u'*A*v)[1];
  
  # ensure we're satisfying properties of an inner product space
  @assert_ae(_dot(u, v), dot(v, u));
  @assert_ae(_dot(u + v, v), _dot(u, v) + _dot(v, v));

  @assert(dot(u, u) >= 0);
  @assert(dot(v, v) >= 0);
  @assert(dot(u, v) <= sqrt(dot(u, u)) * sqrt(dot(v, v)));

  if isposdef(A) # one of the assumptions of the inequality is positive definiteness
    @show u, v, A;
    @show _dot(u, u), _dot(v, v);

    @assert(_dot(u, u) >= 0);
    @assert(_dot(v, v) >= 0);
    @assert(sqrt(_dot(u, u)) * sqrt(_dot(v, v)) - _dot(u, v) > -1e-6);
  end
end

println("Inequality satisfied!");
