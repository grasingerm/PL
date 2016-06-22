A = zeros(100, 500)
B = zeros(100, 500)
bs = rand(size(A, 1), 5)
cs = rand(size(A, 2), size(bs, 2))
println("Why are these times:")
sa1, sa2 = size(A)
sbs = size(bs, 2)
for i = 1:sbs
 @time A += bs[:, i] * transpose(cs[:, i])
end
println("So much faster than these times? Why is this loop allocating so much memory?")
for i = 1:sbs
 @time for j2 = 1:sa2
   for j1 = 1:sa1
     B[j1, j2] += bs[j1, i] * cs[j2, i]
   end
 end
end
@assert vecnorm(A - B) < 1e-6
