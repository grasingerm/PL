function Fn = fib2(n)
  e1 = 1;
  e2 = 2;
  if n == 1
    Fn = e1;
  elseif n == 2
    Fn = e2;
  else
    for i=3:n
      Fn = e2 + e1;
      e1 = e2;
      e2 = Fn;
    end
  end
end
