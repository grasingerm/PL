function pamap_with_indices(f, A)
  np = nprocs();
  ni, nj = size(A);
  results = cell(ni, nj);
  i = 0; j = 1;

  nextidxs() = begin
    idx,jdx = i,j;
    i += 1
    if i > ni; i = 1; j += 1; end
    return idx, jdx;
  end

  @sync begin
    for p=1:np
      if p != myid() || np == 1
        @async begin
          while true
            idx,jdx = nextidxs();
            if jdx > nj; break; end
            results[idx,jdx] = remotecall_fetch(p, f, A[idx,jdx], idx, jdx);
            end
          end
        end
      end
    end
  return results;
end
