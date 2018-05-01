const t = 3;
const p = t / 2;

function _main()
  const c::Float32 = 1.0;
  const b::Float32 = -10^p;

  function algo1(c::Float32, b::Float32, x0::Float32, iters::Int)
    xn::Float32 = x0;
    println("$(0): $xn");
    for iter = 1:iters
      xn = - c/(2*b) - (xn*xn)/(2*b);
      println("$iter: $xn");
    end
    return xn;
  end

  function algo2(c::Float32, b::Float32, x0::Float32, iters::Int)
    xn::Float32 = x0;
    println("$(0): $xn");
    for iter = 1:iters
      xn = xn - (xn*xn + 2*b*xn + c)/(2*xn+2*b);
      println("$iter: $xn");
    end
    return xn;
  end

  println("Initial guess of 0.0...");
  x0::Float32 = 0.0;
  println("Algorithm 1");
  println("===========");
  algo1(c, b, x0, 8);
  println();
  println("Algorithm 2");
  println("===========");
  algo2(c, b, x0, 8);
  println();

  println("Initial guess of -c/b");
  println("Algorithm 1");
  println("===========");
  algo1(c, b, -c/b, 8);
  println();
  println("Algorithm 2");
  println("===========");
  algo2(c, b, -c/b, 8);
end

_main();
