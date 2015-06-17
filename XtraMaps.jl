module XtraMaps

export pmap!, map_with_indices, map_with_indices!, pmap_with_indices, pmap_with_indices!
export mmap_with_indices, mmap_with_indices!, pmmap_with_indices, pmmap_with_indices!
export szeros, sones, sfill

"""
Map over an array in place in parallel
"""
function pmap!(f::Function, lst::SharedArray)
  const np = nprocs();
  const n = length(lst);
  i = 1;
  nextidx() = (idx=i; i+=1; idx);
  @sync begin
    for p=1:np
      if p != myid() || np == 1
        @async begin
          while true
            idx = nextidx()
            if idx > n; break; end
            lst[idx] = remotecall_fetch(p, f, lst[idx]);
          end
        end
      end
    end
  end
end

"""
Map over an array using its index as the second argument
"""
function map_with_indices(f::Function, lst::Array)
  const n = length(lst);
  results = cell(n);
  for i=1:n
    results[i] = f(lst[i], i);
  end
  return results;
end

"""
Map over an array in place using its index as the second argument
"""
function map_with_indices!(f::Function, lst::Array)
  const n = length(lst);
  for i=1:n
    lst[i] = f(lst[i], i);
  end
end

"""
Map over an array in parallel with its index as the second argument
"""
function pmap_with_indices(f::Function, lst::Array)
  const np = nprocs();
  const n = length(lst);
  results = cell(n);
  i = 1;
  nextidx() = (idx=i; i+=1; idx);
  @sync begin
    for p=1:np
      if p != myid() || np == 1
        @async begin
          while true
            idx = nextidx()
            if idx > n; break; end
            results[idx] = remotecall_fetch(p, f, lst[idx], idx);
          end
        end
      end
    end
  end
  return results;
end

"""
Map over an array in place in parallel with its index as the second argument
"""
function pmap_with_indices!(f::Function, lst::SharedArray)
  const np = nprocs();
  const n = length(lst);
  i = 1;
  nextidx() = (idx=i; i+=1; idx);
  @sync begin
    for p=1:np
      if p != myid() || np == 1
        @async begin
          while true
            idx = nextidx()
            if idx > n; break; end
            lst[idx] = remotecall_fetch(p, f, lst[idx], idx);
          end
        end
      end
    end
  end
end

"""
Map over a 2D array with its indices as the second and third args
"""
function mmap_with_indices(f::Function, A::Array)
  const ni, nj = size(A);
  results = cell(ni, nj);

  for j=1:nj, i=1:ni
    results[i,j] = f(A[i,j], i, j);
  end
  return results;
end

"""
Map over a 2D array in place with its indices as the second and third args
"""
function mmap_with_indices!(f::Function, A::Array)
  const ni, nj = size(A);
  for j=1:nj, i=1:ni
    A[i,j] = f(A[i,j], i, j);
  end
end

"""
Map over a 2D array in parallel with its indices as the second and third args
"""
function pmmap_with_indices(f::Function, A::Array)
  const np = nprocs();
  const ni, nj = size(A);
  results = cell(ni, nj);
  i = 1; j = 1;

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

"""
Map over a 2D array in place in parallel with its indices as 2nd and 3rd args
"""
function pmmap_with_indices!(f::Function, S::SharedArray)
  const np = nprocs();
  const ni, nj = size(S);
  i = 1; j = 1;

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
            S[idx,jdx] = remotecall_fetch(p, f, S[idx,jdx], idx, jdx);
          end
        end
      end
    end
  end
end

sones(dims) = SharedArray(Float64, dims, init = S -> S[localindexes(S)] = 1);
szeros(dims) = SharedArray(Float64, dims, init = S -> S[localindexes(S)] = 0);
sfill(fill, dims) = SharedArray(typeof(fill), dims, init = S -> S[localindexes(S)] = fill);

sones(t, dims) = SharedArray(t, dims, init = S -> S[localindexes(S)] = 1);
szeros(t, dims) = SharedArray(t, dims, init = S -> S[localindexes(S)] = 0);

end
