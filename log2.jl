using PyPlot;

partial_sums = Float64[];
sum_idxs = Int[];

sum = 1.0;
for n = 1:100
  sum += (-1)^n * (1 / (n+1));
  if n % 1 == 0
    push!(partial_sums, sum);
    push!(sum_idxs, n);
    println("n = ", n, ", Sn = ", sum, ", log2 = ", log(2));
  end
end

plot(sum_idxs, partial_sums);
show();
