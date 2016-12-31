type BC
  condition::Function;
  u::Real;

  BC(condition::Function, u::Real = 0.0) = new(condition, u);
end

function enforce_bcs!(gdofs::Matrix{Int}, gcoords::Matrix{Float64}, 
                      K::Matrix{Float64}, f::Vector{Float64}, bcs::Vector{BC})
  const nnodes = size(gcoords, 2);

  for i=1:nnodes

    ncoords = gcoords[:, i];
    bc_enforced = false;

    for bc in bcs
      if bc.condition(ncoords)
        if bc_enforced
          @assert(bc.u == f[i], "Boundary conditions do not agree!");
          continue;
        else
          bc_enforced = true;
          for j=1:nnodes
            if i == j
              K[i, i] = 1.0;
              f[i] = bc.u;
            else
              f[i] -= K[j, i] * bc.u;
              K[i, j] = 0.0;
              K[j, i] = 0.0;
            end
          end
        end
      end
    end

  end
end
