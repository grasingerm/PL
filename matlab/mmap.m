function ys = mmap(f, xs)
  n = length(xs);
  ys = zeros(n, 1);
  for i=1:n
    ys(i) = f(xs(i));
  end
end