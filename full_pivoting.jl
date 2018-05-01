function gauss_elim_full(A::Matrix{Float64}, b::Vector{Float64})
  const n = size(A, 1);
  vars = collect(1:n);
  @assert(n == size(A, 2));
  for j=1:n-1
    # find max pivot
    maxv = A[j, j];
    maxi, maxk = (j+1, j);
    for i=j:n, k=j:n
      if abs(A[i, k]) > abs(maxv)
        maxv = A[i, k];
        maxi, maxk = i, k;
      end
    end

    # column exchange
    if maxk != j
      # book keeping
      temp = vars[j];
      vars[j] = vars[maxk];
      vars[maxk] = temp;

      # exchange
      temp_col = A[:, j];
      A[:, j] = A[:, maxk];
      A[:, maxk] = temp_col;
    end

    # row exchange
    if maxi != j
      temp_row = A[j, :];
      A[j, :] = A[maxi, :];
      A[maxi, :] = temp_row;

      temp = b[j];
      b[j] = b[maxi];
      b[maxi] = temp;
    end

    # elimination
    const pivot = A[j, j];
    for i=j+1:n
      c = A[i, j] / pivot;
      A[i, j:n] -= c * A[j, j:n];
      b[i] -= c * b[j];
    end
  end

  y = zeros(n);
  y[n] = b[n] / A[n, n];
  for i=n-1:-1:1
    sum = 0;
    for j=i+1:n; sum += A[i, j] * y[j]; end
    y[i] = (b[i] - sum) / A[i, i];
  end

  x = zeros(n);
  for i=1:n; x[vars[i]] = y[i]; end
  return x;
end

A = Float64[1 2; 3 4]
b = Float64[1; -1];

println(gauss_elim_full(A, b));

println(gauss_elim_full(Float64[1 1 1; 4 -4 0; -2 2 -11], Float64[3; 0; -11]));

for i=1:10
  n = rand(2:12);
  A = rand(n, n);
  b = rand(n);

  xjulia = A \ b;
  xme = gauss_elim_full(A, b);

  for j=1:n
    println("x($j) = $(xjulia[j]) = $(xme[j])");
  end
  println();
end
