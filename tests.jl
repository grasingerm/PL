using Base.Test

require("XtraMaps.jl");

@everywhere f(x) = begin; sleep(0.5); 2x; end
a, b = ones(20), sones(20);
print("map!: "); @time map!(f,a);
print("pmap!: "); @time pmap!(f,b);
for i=1:20; @test a[i] == b[i]; end

@everywhere g(x, y) = begin; sleep(0.1); 2x-y; end
c, d = ones(50), sones(50);
print("map_with_indices: "); @time x = map_with_indices(g,c);
print("pmap_with_indices: "); @time y = pmap_with_indices(g,c);
print("map_with_indicies!: "); @time map_with_indices!(g,c);
print("pmap_with_indicies!: "); @time pmap_with_indices!(g,d);
for i=1:50
  @test c[i] == d[i] && c[i] == x[i] && c[i] == y[i];
end

@everywhere h(x, y, z) = begin; sleep(0.08); x^2 + 119y - z^2; end
A, B = fill(1.3, (7, 6)), sfill(1.3, (7, 6));
print("mmap_with_indices: "); @time C = mmap_with_indices(h,A);
print("pmmap_with_indices: "); @time D = pmmap_with_indices(h,A);
print("mmap_with_indices!: "); @time mmap_with_indices!(h,A);
print("pmmap_with_indices!: "); @time pmmap_with_indices!(h,B);
for j=1:6, i=1:7
  @test_approx_eq A[i,j] B[i,j]
  @test_approx_eq A[i,j] C[i,j]
  @test_approx_eq A[i,j] D[i,j]
end
