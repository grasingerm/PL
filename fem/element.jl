N1(ξ::Real, η::Real) = 0.25 * (1.0 - ξ) * (1.0 - η);
N2(ξ::Real, η::Real) = 0.25 * (1.0 + ξ) * (1.0 - η);
N3(ξ::Real, η::Real) = 0.25 * (1.0 + ξ) * (1.0 + η);
N4(ξ::Real, η::Real) = 0.25 * (1.0 - ξ) * (1.0 + η);

N = [N1; N2; N3; N4];

N1ξ(ξ::Real, η::Real) = -0.25 * (1.0 - η);
N2ξ(ξ::Real, η::Real) =  0.25 * (1.0 - η);
N3ξ(ξ::Real, η::Real) =  0.25 * (1.0 + η);
N4ξ(ξ::Real, η::Real) = -0.25 * (1.0 + η);

N1η(ξ::Real, η::Real) = -0.25 * (1.0 - ξ);
N2η(ξ::Real, η::Real) = -0.25 * (1.0 + ξ);
N3η(ξ::Real, η::Real) =  0.25 * (1.0 + ξ);
N4η(ξ::Real, η::Real) =  0.25 * (1.0 - ξ);

B = [N1ξ N2ξ N3ξ N4ξ;
     N1η N2η N3η N4η];

_GP = Vector{Float64}[
  [0.0],
  [-sqrt(1.0 / 3.0); sqrt(1.0 / 3.0)],
  [-sqrt(3.0 / 5.0); 0.0; sqrt(3.0 / 5.0)]
];

_GW = Vector{Float64}[
  [2.0],
  [1.0; 1.0],
  [5.0 / 9.0; 8.0 / 9.0; 5.0 / 9.0]
];

function quad_1p2d(f::Function)
  return _GW[1][1] * _GW[1][1] * f(_GP[1][1], _GP[1][1]);
end

function quad_2p2d(f::Function)
  sum = 0.0;
  for i=1:2, j=1:2
    sum += _GW[2][i] * _GW[2][j] * f(_GP[2][i], _GP[2][j]);
  end
  return sum;
end

function quad_3p2d(f::Function)
  sum = 0.0;
  for i=1:3, j=1:3
    sum += _GW[3][i] * _GW[3][j] * f(_GP[3][i], _GP[3][j]);
  end
  return sum;
end

function mesh_rectangle(x0::Real, x1::Real, y0::Real, y1::Real, nx::Int, ny::Int)
  dx = (x1 - x0) / nx;
  dy = (y1 - y0) / ny;
  gdofs = Matrix{Int}(4, nx*ny);
  gcoords = Matrix{Float64}(2, (nx+1)*(ny+1));
  for i = 1:size(gdofs, 2)
    row = (i % nx == 0) ? i ÷ nx - 1 : i ÷ nx;
    gdofs[:, i] = [i+row; i+row+1; i+row+nx+2; i+row+nx+1];
  end
  idx = 1;
  for i = 0:ny, j = 0:nx
    gcoords[:, idx] = [x0 + dx * j; y0 + dy * i];
    idx += 1;
  end
  return gdofs, gcoords;
end

function J(xs::Matrix{Float64}, ξ::Real, η::Real)
  const N_ = [
              N1ξ(ξ, η) N2ξ(ξ, η) N3ξ(ξ, η) N4ξ(ξ, η); 
              N1η(ξ, η) N2η(ξ, η) N3η(ξ, η) N4η(ξ, η)
             ];
  return det(N_ * xs);
end

function xse(gdofs::Matrix{Int}, gcoords::Matrix{Float64}, elemidx::Int)
  const nnodes = size(gdofs, 1);
  xs = Matrix{Float64}(nnodes, 2);

  for i=1:nnodes
    gidx = gdofs[i, elemidx];
    xs[i, :] = map(i -> gcoords[i, gidx], 1:2);
  end

  return xs;
end
