using FastAnonymous

function yolo()
  return (@anon x -> 2*sin(x) + x^2);
end

function yolo2()
  return (@anon (x, y) -> x + y);
end

a = yolo()
println(map(a, 1:10));

b = yolo2()
println(b(1, 2.4));
