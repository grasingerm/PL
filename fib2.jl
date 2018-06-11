function fib_tail(n::Int)
  return (n > 1) ? fib_tail(n-1) + fib_tail(n-2) : n;
end

function fib_head(n::Int)
  return NaN
end
