using FastAnonymous

function yolo()
  return f = @anon x -> 2*sin(x) + x^2;
end

a = yolo()
println(map(a, 1:10));
