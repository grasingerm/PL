@everywhere import DistributedArrays

function life_step(d::DistributedArrays.DArray)
  DistributedArrays.DArray(size(d), procs(d)) do I
    top = mod(first(I[1]) - 2, size(d, 1)) + 1;
    bot = mod(last(I[1]), size(d, 1)) + 1;
    left = mod(first(I[2]) - 2, size(d, 2)) + 1;
    right = mod(last(I[2]), size(d, 2)) + 1;

    old = Array(Bool, length(I[1]) + 2, length(I[2]) + 2)
    old[1       , 1       ]         =   d[top  ,   left];
    old[2:end-1 , 1       ]         =   d[I[1] ,   left];
    old[end     , 1       ]         =   d[bot  ,   left];
    old[1       , 2:end-1 ]         =   d[top  ,   I[2]];
    old[2:end-1 , 2:end-1 ]         =   d[I[1] ,   I[2]];
    old[end     , 2:end-1 ]         =   d[bot  ,   I[2]];
    old[1       , end     ]         =   d[top  ,  right];
    old[2:end-1 , end     ]         =   d[I[1] ,  right];
    old[end     , end     ]         =   d[bot  ,  right];

    life_rule(old)
  end
end

function life_rule(old)
  m, n = size(old);
  nnew = similar(old, m-2, n-2);
  for j = 2:n-1
    for i = 2:m-1
      nc = +(old[i-1,j-1], old[i-1,j], old[i-1,j+1],
             old[i  ,j-1],             old[i  ,j+1],
             old[i+1,j-1], old[i+1,j], old[i+1,j+1]);
      nnew[i-1,j-1] = (nc == 3 || nc == 2 && old[i,j]);
    end
  end
  return nnew;
end
