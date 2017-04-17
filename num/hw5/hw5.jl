asoln(x, y, t) = exp(0.75 * t) * sin(2 * x * y) * cosh(1.5 * (x + y));

for h in [1/10; 1/20; 1/40]
  const k = h;

  const aax = -k / (2 * h*h);
  const bbx = (k / (h*h) + 1);
  const ccx = aax;

  const aay = -k / (h*h);
  const bby = (2 * k / (h*h) + 1);
  const ccy = aax;

  xs = linspace(0.0, 1.0, Int(round(1.0 / h)));
  ys = copy(xs);
  ts = linspace(0.0, 1.0, Int(round(1.0 / k)));
  const M, L, K = length(xs), length(ys), length(ts);

  u = zeros(M, L, K);
  for (m, x) in zip(1:M, xs), (l, y) in zip(1:L, ys)
    u[m, l, 1] = asoln(x, y, 0);
  end
  
  @time for n in 1:K-1
    for l in 2:L-1 # consider boundary terms
      # calculate pi and qi for Thomas' algorithm
      p = zeros(L);
      q = zeros(L);
      p[2], q[2] = 0.0, asoln(0.0, ys[l], ts[n+1]);
      for m=2:M-1
        dd = u[m, l, n] + (k / (h*h) * 
                           (u[m, l+1, n] - 2 * u[m, l, n] + u[m, l-1, n]));
        denom = aax * p[m] + bbx;
        p[m+1] =  -ccx / denom;
        q[m+1] = (ddx - aax * q[m]) / denom;
      end
      u[M, l, n+1] = asoln(1.0, ys[l], ts[n+1]);
      for m=M-1:-1:1
        u[m, l, n+1] = p[m+1] * u[m+1, l, n+1] + q[m+1];
      end
    end

    for m in 1:M
      # calculate pi and qi for Thomas' algorithm
      p = zeros(M);
      q = zeros(M);
      p[2], q[2] = 0.0, asoln(xs[m], 0.0, ts[n+1]);
      for l=2:L-1
        # Note: n+1 is because we need to use values calculated in last sweep
        dd = u[m, l, n+1] + (k / (2*h*h) * 
                         (u[m+1, l, n+1] - 2 * u[m, l, n+1] + u[m-1, l, n+1]));
        denom = aay * p[m] + bby;
        p[m+1] =  -ccy / denom;
        q[m+1] = (ddy - aay * q[m]) / denom;
      end
      u[m, L, n+1] = asoln(xs[m], 1.0, ts[n+1]);
      for m=M-1:-1:1
        u[m, l, n+1] = p[m+1] * u[m, l+1, n+1] + q[m+1];
      end
    end

    err = zeros(M, L);
    for (m, x) in zip(1:M, xs), (l, y) in zip(1:L, ys)
      err[m, l] = u[m, l, n+1] - asoln(x, y, ts[n+1]);
    end
    println("Error at t=$(ts[n+1]): ", norm(err, 2));
  end
end
