function Fn = fib(n)
  if n == 1
    Fn = 1;
  elseif n == 2
    Fn = 2;
  else
    Fn = fib(n-1) + fib(n-2);
  end
end
