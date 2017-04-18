using PyPlot;

asoln(x, y, t) = exp(0.75 * t) * sin(2 * x * y) * cosh(1.5 * (x + y));

const debug_flag = true;

macro if_debug(code)
  if debug_flag
    return code;
  end
end

for h in [1/10; 1/20; 1/40]
  w = open("h-$h.csv", "w");

  const μ = 1.0;
  const k = μ * h*h;
  println("k = $k, h = $h");

  const aax = -k / (2 * h*h);
  const bbx = (k / (h*h) + 1);
  const ccx = aax;

  const aay = -k / (h*h);
  const bby = (2 * k / (h*h) + 1);
  const ccy = aay;

  xs = linspace(0.0, 1.0, Int(round(1.0 / h)));
  ys = copy(xs);
  ts = linspace(0.0, 1.0, Int(round(1.0 / k)));
  const M, L, K = length(xs), length(ys), length(ts);

  u = zeros(M, L, K);
  for (m, x) in zip(1:M, xs), (l, y) in zip(1:L, ys)
    u[m, l, 1] = asoln(x, y, 0);
  end
  u_debug = (debug_flag) ? zeros(M, L, K) : zeros(1, 1, 1);
  @if_debug(for (m, x) in zip(1:M, xs), (l, y) in zip(1:L, ys)
    u_debug[m, l, 1] = asoln(x, y, 0);
  end);
 
  for n in 1:K-1
    # calculate boundary terms
    for l in 1:L
      u[1, l, n+1] = asoln(0.0, ys[l], ts[n+1]);
      u[M, l, n+1] = asoln(1.0, ys[l], ts[n+1]);
    end
    for m in 2:M-1
      u[m, 1, n+1] = asoln(xs[m], 0.0, ts[n+1]);
      u[m, L, n+1] = asoln(xs[m], 1.0, ts[n+1]);
    end

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
        q[m+1] = (dd - aax * q[m]) / denom;
      end
      u[M, l, n+1] = asoln(1.0, ys[l], ts[n+1]);
      for m=M-1:-1:2
        u[m, l, n+1] = p[m+1] * u[m+1, l, n+1] + q[m+1];
      end
    end

    for m in 2:M-1
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
        q[m+1] = (dd - aay * q[m]) / denom;
      end
      u[m, L, n+1] = asoln(xs[m], 1.0, ts[n+1]);
      for l=L-1:-1:2
        u[m, l, n+1] = p[m+1] * u[m, l+1, n+1] + q[m+1];
      end
    end

    @if_debug(begin
        for l in 1:L
          u_debug[1, l, n+1] = asoln(0.0, ys[l], ts[n+1]);
          u_debug[M, l, n+1] = asoln(1.0, ys[l], ts[n+1]);
        end
        for m in 2:M-1
          u_debug[m, 1, n+1] = asoln(xs[m], 0.0, ts[n+1]);
          u_debug[m, L, n+1] = asoln(xs[m], 1.0, ts[n+1]);
        end
        for l in 2:L-1, m in 2:M-1
          u_debug[m, l, n+1] = k / (h*h) * (u_debug[m+1, l, n] - 2 * u_debug[m, l, n] 
                                            + u_debug[m-1, l, n] + 
                                            2 * (u_debug[m, l+1, n] - 2 * u_debug[m, l, n] 
                                                 + u_debug[m, l-1, n])) + u_debug[m, l, n];
        end
      end);

    for m in 1:M, l in 1:L
      write(w, "$(ts[n+1]), $(xs[m]), $(ys[l]), $(u[m, l, n+1]), $(asoln(xs[m], ys[l], ts[n+1])), $(u_debug[m, l, n+1])\n");
    end
  end
  close(w);
end
