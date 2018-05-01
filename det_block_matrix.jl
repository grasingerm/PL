for k=1:1000
  A = rand(-10:10, 4, 4,);
  #test_det = (det(A[1:2,1:2])*det(A[3:4,3:4]) - det(A[1:2,3:4])*det(A[3:4,1:2]));
  test_det = (det(A[1:2,1:2]*A[3:4,3:4]) - det(A[1:2,3:4]*A[3:4,1:2]));
  @show test_det, det(A)
  @assert(abs((det(A)-test_det)/det(A)) < 1e-6);
end
