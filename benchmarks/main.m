disp('Testing recursive fibanocci function');
fib(4);
for i=1:3
  n = 10 * i;
  tic();
  f = fib(n);
  toc();
  %disp(['F', num2str(n), ' = ', num2str(f)]);
end

fprintf('\nTesting nonrecursive fibanocci function\n');
fib2(4);
for i=2:4
  n = 10 * i;
  tic();
  f = fib2(n);
  toc();
  %disp(['F', num2str(n), ' = ', num2str(f)]);
end

fprintf('\nTesting matrix multiplication\n');
rand(3,3)*rand(3,3);
for i=1:5
  if i == 2
    continue;
  end
  A = dlmread(strcat('A', num2str(i), '.dsv'));
  B = dlmread(strcat('B', num2str(i), '.dsv'));
  %fprintf('A is %d by %d, and B is %d by %d\n', size(A,1), size(A,2), ...
  %        size(B,1), size(B,2));
  tic();
  C = A * B;
  toc();
end

fprintf('\nTesting solution of linear systems\n');
rand(3,3)\rand(3,1);
for i=1:5
  if i == 2
    continue;
  end
  A = dlmread(strcat('A', num2str(i), '.dsv'));
  b = dlmread(strcat('b', num2str(i), '.dsv'));
  %fprintf('A is %d by %d, and b is %d by %d\n', size(A,1), size(A,2), ...
  %        size(b,1), size(b,2));
  tic();
  C = A \ b;
  toc();
end

fprintf('\nFinding prime numbers\n');
prime(10);
for i=1:5
  n = i^2*1000;
  tic();
  markers = prime(n);
  toc();
  %disp(['Prime numbers less than or equal to ', num2str(n)]);
  %for i=1:length(markers)
  %  if markers(i) == 1
  %    fprintf('%d ', i+1);
  %  end
  %end
  %fprintf('\n');
end
