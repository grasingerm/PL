using PyPlot;

immutable Gas; end          const GAS         = Gas();
immutable Fluid; end        const FLUID       = Fluid();
immutable Interface; end    const INTERFACE   = Interface();

typealias State Union{Gas, Fluid, Interface};

macro debug_mass_cons(code, opname, m)
  return quote
    init_mass = sum($m);
    $code;
    println("Change in mass for ", $opname, ": ", sum($m) - init_mass);
  end;
end

# Map particle distribution functions to macroscopic variables
function map_to_macro!(f::Array{Float64, 3}, c::Matrix{Int64}, 
                       ρ::Matrix{Float64}, u::Array{Float64, 3})
  const ni, nj = size(ρ);
  const nk     = size(f, 1);

  for j=1:nj, i=1:ni
    ρ[i,j]    = 0.0;
    u[1,i,j]  = 0.0;
    u[2,i,j]  = 0.0;

    for k=1:nk
      ρ[i,j]  +=  f[k,i,j];
      u[1,i,j]  +=  c[1,k] * f[k,i,j];
      u[2,i,j]  +=  c[2,k] * f[k,i,j];
    end

    u[1,i,j]  /=  ρ[i,j];
    u[2,i,j]  /=  ρ[i,j];
  end
end

# Initialize simulation variables
function init!(f, c, w, ρ, u, m, ϵ, states, ρ_0; fill_x::Real=0.5, fill_y=1.0)
  const ni, nj  =   size(ρ);
  const fill_ni =   convert(Int, fill_x * ni);
  const fill_nj =   convert(Int, fill_y * nj);
  const nk      =   length(w);

  for j=1:nj, i=1:ni, k=1:nk
    f[i,j]      =   ρ_0 / w[k];
  end

  map_to_macro!(f, c, ρ, u);

  for j=1:fill_nj, i=1:fill_ni
    m[i,j]      =   ρ[i,j];
    ϵ[i,j]      =   1.0;
    states[i,j] =   FLUID;
  end

  for j=1:fill_nj
    const i     =   fill_ni + 1;

    m[i,j]      =   ρ[i,j] / 2.0;
    ϵ[i,j]      =   0.5;
    states[i,j] =   INTERFACE;
  end
end

const _NBRS     =   [(1, 0), (-1, 0), (0, 1), (1, 1), (-1, 1), (0, -1), (1, -1), 
                     (-1, -1)];

# Return index of lattice vector in the opposite direction
function _opp_k(k::Int)
  if k == 1
    return 3;
  elseif k == 2
    return 4;
  elseif k == 3
    return 1;
  elseif k == 4
    return 2;
  elseif k == 5
    return 7;
  elseif k == 6
    return 8;
  elseif k == 7
    return 5;
  elseif k == 8
    return 6;
  elseif k == 9
    return 9;
  else
    error("This is bullshit");
    return -999;
  end
end

# Mass transfer across interface cells
function masstransfer!(f::Array{Float64, 3}, c::Matrix{Int64}, 
                       ϵ::Matrix{Float64}, m::Matrix{Float64}, 
                       states::Matrix{State})

  const ni, nj    =     size(states);
  const nk        =     size(c, 2);

  dm              =     0.0;

  for j=1:nj, i=1:ni
    if state[i,j] == INTERFACE
      for k=1:nk-1
        const i_nbr   =   i + c[1,k];
        const j_nbr   =   j + c[2,k];

        if (i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj ||
            states[i_nbr, j_nbr] == GAS) # if out of bounds or at a gas cell
          continue;
        end

        const opp_k   =   _opp_k(k);

        if states[i_nbr, j_nbr]     ==  FLUID
          dm  +=  m[i,j]  +=  f[opp_k, i_nbr, j_nbr] - f[k, i, j];
        elseif states[i_nbr, j_nbr] ==  INTERFACE
          dm  +=  m[i,j]  +=  (0.5 * (ϵ[i_nbr, j_nbr] + ϵ[i, j]) * 
                               (f[opp_k, i_nbr, j_nbr] - f[k, i, j]));
        else; error("State $(states[i_nbr, j_nbr]), not understood");
        end

      end # for each neighbor
    end # only transfer mass across interface cells
  end # for each node

  return dm; # THIS SHOULD BE ZERO

end

# stream particle distribution functions
function stream!(f::Array{Float64, 3}, c::Matrix{Int64}, states::Matrix{State})
  const ni, nj  =   size(states);
  const nk      =   size(c, 2);

  f_new         =   copy(f);
  
  for j=1:nj, i=1:ni, k=1:nk-1

    if states[i, j] == GAS; continue; end

    const i_nbr   =   i + c[1,k];
    const j_nbr   =   j + c[2,k];

    if (i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj ||
        states[i_nbr, j_nbr] == GAS) # if out of bounds or at a gas cell
      continue;
    end

    f_new[k, i_nbr, j_nbr] = f[k, i, j];

  end

  copy!(f, f_new);
end

# Main function
function _main()
  const   nx::UInt      =     100;
  const   ny::UInt      =     100;

  const   nu            =     0.2;
  const   ω             =     1.0 / (nu + 0.5);
  const   ρ_0           =     1.0;

  const   κ             =     1.0e-3;
  
  const   nsteps::UInt  =     40000;

  const   c             =     (Int64[1 0; 0 1; -1 0; 0 -1; 1 1; -1 1; -1 -1; 
                                     1 -1; 0 0]');
  const   w             =     (Float64[1.0/9.0; 1.0/9.0; 1.0/9.0; 1.0/9.0; 
                                       1.0/36.0; 1.0/36.0; 1.0/36.0; 1.0/36.0; 
                                       4.0/9.0]);

  f                     =     zeros(Float64, 9, nx, ny);
  ρ                     =     zeros(Float64, nx, ny);
  u                     =     zeros(Float64, 2, nx, ny);
  m                     =     zeros(Float64, nx, ny);
  ϵ                     =     zeros(Float64, nx, ny);

  states                =     Array{State, 2}(nx, ny);
  fill!(states, GAS);

  init!(f, c, w, ρ, u, m, ϵ, states, ρ_0);

  # iterate through time steps
  for step=1:nsteps
    # mass transfer
    @debug_mass_cons(@show masstransfer!(f, ϵ, m), "mass transfer", m);

    # stream
    stream!(f, c, states);

    # reconstruct DFs from empty cells
    reconstruct_from_empty!();

    # reconstruct DFs along interface normal
    reconstruct_from_interface!();

    # perform collision
    collide!();

    # boundary conditions
    boundary_conditions!();

    # update cell states
    update_cell_states!();
  end

end

_main();
