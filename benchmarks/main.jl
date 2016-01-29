fib(n::Int) = (n == 1) ? 1 : (n == 2) ? 2 : fib(n-1) + fib(n-2);

function fib2(n::Int)
  e1 = 1;
  e2 = 2;

  if     n == 1; return e1;
  elseif n == 2; return e2;
  else

    Fn = 0;

    for i=3:n
      Fn = e2 + e1;
      e1 = e2;
      e2 = Fn;
    end

    return Fn;

  end
end

function prime(n::Int)
  markers = ones(n-1, 1);

  i = 1;
  while i < n
    # Find next prime number
    while markers[i] != 1
      i = i + 1;
      if i > n-1
        break;
      end
    end

    # Initialize current prime and multiplier
    p = i + 1;
    m = p;

    # Mark all multiples of the current prime as not prime
    while m * p <= n
      markers[m * p - 1] = 0;
      m = m + 1;
    end

    i = i + 1;
  end

  return markers;
end

println("\nTesting recursive fibanocci function");
fib(4);
for i=1:3
  n = 10 * i;
  tic();
  f = fib(n);
  toc();
  #println("F", n, " = ", f);
end

println("\nTesting nonrecursive fibanocci function");
fib2(4);
for i=2:4
  n = 10 * i;
  tic();
  f = fib2(n);
  toc();
  #println("F", n, " = ", f);
end

println("\nTesting matrix multiplication");
rand(3,3)*rand(3,3);
for i=1:4
  if i == 2
    continue;
  end
  A = readdlm("A$i.dsv");
  B = readdlm("B$i.dsv");
  #@printf("A is %d by %d, and B is %d by %d\n", size(A,1), size(A,2),
  #        size(B,1), size(B,2));
  tic();
  C = A * B;
  toc();
end

println("\nTesting solution of linear systems");
rand(3,3)\rand(3,1);
for i=1:4
  if i == 2
    continue;
  end
  A = readdlm("A$i.dsv");
  b = readdlm("b$i.dsv");
  #@printf("A is %d by %d, and b is %d by %d\n", size(A,1), size(A,2),
  #        size(b,1), size(b,2));
  tic();
  C = A \ b;
  toc();
end

println("\nFinding prime numbers");
prime(10);
for i=1:5
  n = i^2*1000
  tic();
  markers = prime(n);
  toc();
  #println("Prime numbers less than or equal to ", n);
  #for i=1:length(markers)
  #  if markers[i] == 1
  #    @printf("%d ", i+1);
  #  end
  #end
  #@printf("\n");
end
