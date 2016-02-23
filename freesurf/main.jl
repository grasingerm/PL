using PyPlot;
using List;

immutable Gas; end;          const GAS         = Gas();
immutable Fluid; end;        const FLUID       = Fluid();
immutable Interface; end;    const INTERFACE   = Interface();

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

#! equilibrium distribution function
function feq(ρ_ij::Real, w_k::Real, c_k::Vector{Float64}, u_ij::Vector{Float64})
  const cdotu = dot(c_k, u_ij);
  return w_k * (ρ_ij + 3*cdotu - 3/2*dot(u_ij, u_ij) + 9/2*(cdotu)^2);
end

# Reconstruct distributions functions from "empty" space
function reconstruct_from_empty!(f::Array{Float64, 3}, w::Vector{Float64},
                                 c::Matrix{Int64}, u::Array{Float64, 3},
                                 ϵ::Matrix{Float64}, states::Matrix{State}, 
                                 ρ_A::Real)
  
  const ni, nj  = size(states);
  const nk      =   size(c, 2);

  for j=1:nj, i=1:ni, k=1:nk-1
    if states[i, j] != INTERFACE; continue; end # only reconstruct at interface

    const i_nbr     =   i + c[1,k];
    const j_nbr     =   j + c[2,k];

    if (i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj ||
        states[i_nbr, j_nbr] != GAS)
      continue;
    end
    
    const opp_k     =   _opp_k(k);
    const u_ij      =   u[:, i, j];

    f[opp_k, i, j]  =   (feq(ρ_A, w[k], c[:, k], u_ij) + 
                         feq(ρ_A, w[opp_k], c[:, opp_k], u_ij) - f[k, i, j]);
  end
end

#TODO some if statements could move up out of an inner loop :( (duh)

# Reconstruct distributions functions normal to interface
function reconstruct_from_normal!(f::Array{Float64, 3}, w::Vector{Float64},
                                  c::Matrix{Int64}, u::Array{Float64, 3},
                                  ϵ::Matrix{Float64}, states::Matrix{State}, 
                                  ρ_A::Real)
  
  const ni, nj  = size(states);
  const nk      =   size(c, 2);

  for j=1:nj, i=1:ni, k=1:nk-1
    if states[i, j] != INTERFACE; continue; end # only reconstruct at interface

    const ϵ_il      =   (i <= 1)  ? 0.0 : ϵ[i-1, j];
    const ϵ_ir      =   (i >= ni) ? 0.0 : ϵ[i+1, j];
    const ϵ_jd      =   (j <= 1)  ? 0.0 : ϵ[i, j-1];
    const ϵ_ju      =   (j >= nj) ? 0.0 : ϵ[i, j+1];

    const n_int     =   1/2 * Float64[ϵ_il - ϵ_jl; ϵ_jd - ϵ_ju];
    const c_k       =   c[:, k];

    if dot(n_int, c_k) > 0
      const opp_k     =   _opp_k(k);
      const u_ij      =   u[:, i, j];

      f[opp_k, i, j]  =   (feq(ρ_A, w[k], c_k, u_ij) + 
                           feq(ρ_A, w[opp_k], c[:, opp_k], u_ij) - f[k, i, j]);
    end
  end
end

# Relax toward equilibrium
function collide!(f::Array{Float64, 3}, w::Vector{Float64}, c::Matrix{Int64},
                  ρ::Matrix{Float64}, u::Array{Float64, 3}, ω::Real,
                  ϵ::Matrix{Float64}, states::Matrix{State}, g::Vector{Float64})

  const ni, nj  = size(states);
  const nk      =   size(c, 2);

  for j=1:nj, i=1:ni, k=1:nk
    if states[i, j] != GAS
      f[k, i, j] += (ω * (feq(ρ[i, j], w[k], c[:, k], u[:, i, j]) - f[k, i, j])
                     + ϵ[i, j] * w[k] * 3.0 * dot(g, c[:, k]));
    end
  end
end

#! Enforce boundary conditions
function boundary_conditions!(f::Array{Float64, 3}, states::Matrix{State})
  const ni, nj  = size(states);

  for i=1:ni
    if states[i, 1]   != GAS
      # south wall
      f[2, i, 1]    =   f[4, i, 1]; 
      f[5, i, 1]    =   f[7, i, 1]; 
      f[6, i, 1]    =   f[8, i, 1];
    end

    if states[i, nj]  != GAS
      # north wall
      f[4, i, nj]   =   f[2, i, nj];
      f[7, i, nj]   =   f[5, i, nj];
      f[8, i, nj]   =   f[6, i, nj];
    end
  end

  for j=1:nj
    if states[1, j]   != GAS 
      # west wall
      f[1, 1, j]    =   f[3, 1, j]; 
      f[5, 1, j]    =   f[7, 1, j]; 
      f[8, 1, j]    =   f[6, 1, j]; 
    end

    if states[ni, j]  != GAS
      # north wall
      f[3, ni, j]    =   f[1, ni, j]; 
      f[7, ni, j]    =   f[5, ni, j]; 
      f[6, ni, j]    =   f[8, ni, j]; 
    end
  end
end

# Update fluid fraction of each interface cell
function update_fluid_fraction!(ρ::Matrix{Float64}, ϵ::Matrix{Float64}, 
                                m::Matrix{Float64}, states::Matrix{State},
                                κ::Real)
  const ni, nj      = size(states);
  new_empty_cells   = DoublyLinkedList{Tuple{Int, Int}}();
  new_fluid_cells   = DoublyLinkedList{Tuple{Int, Int}}();
  
  for j=1:nj, i=1:ni
    if states[i, j] != INTERFACE; continue; end
    ϵ[i, j] = ρ[i, j] / m[i, j];

    if      m[i, j] > (1 + κ) * ρ[i, j]
      push!(new_fluid_cells, (i, j));
    elseif  m[i, j] < -κ * ρ[i, j]
      push!(new_empty_cells, (i, j));
    end
  end

  return new_empty_cells, new_fluid_cells;
end

# Update cell states
function update_cell_states!(f::Array{Float64, 3}, c::Matrix{Int64}, 
                             w::Matrix{Float64},
                             ρ::Matrix{Float64}, u::Array{Float64},
                             ϵ::Matrix{Float64}, m::Matrix{Float64}, 
                             states::Matrix{State},
                             new_empty_cells::DoublyLinkedList{Tuple{Int, Int}},
                             new_fluid_cells::DoublyLinkedList{Tuple{Int, Int}})

  const ni, nj  = size(states);
  const nk      = size(c, 2);
  
  for node in new_fluid_cells # First the neighborhood of all filled cells are prepared
    const i, j      =     node.val;
    states[i, j]    =     FLUID;

    # Calculate the total density and velocity of the neighborhood
    ρ_sum           =     0.0;
    u_sum           =     Float64[0.0; 0.0];
    counter::UInt   =     0;
    for k=1:nk-1
      const i_nbr     =     i + c[1, k];
      const j_nbr     =     j + c[2, k];

      if (i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj ||
          states[i_nbr, j_nbr] == GAS)
        continue;
      end

      counter         +=     1;

      ρ_sum           +=     ρ[i_nbr, j_nbr];
      u_sum           +=     u[:, i_nbr, j_nbr];
    end
    ρ_avg           =       ρ_sum / counter;
    u_avg           =       u_sum / counter;

    cells_to_redist_to  =   DoublyLinkedList{Tuple{Int, Int}}();
    counter             =   0;

    # Construct interface cells from neighborhood average at equilibrium
    for k=1:nk-1
      const i_nbr     =     i + c[1, k];
      const j_nbr     =     j + c[2, k];

      if i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj
        continue;
      end

      if states[i_nbr, j_nbr] == FLUID
        push!(cells_to_redist_to, (i_nbr, j_nbr));
        counter +=  1;
        continue;
      end

      # If it is already an interface cell, make sure it is not emptied
      if states[i_nbr, j_nbr] == INTERFACE
        remove!(new_empty_cells, (i_nbr, j_nbr));
        push!(cells_to_redist_to, (i_nbr, j_nbr));
        counter +=  1;
      else
        states[i_nbr, j_nbr] = INTERFACE;
        for kk=1:nk
          f[kk, i_nbr, j_nbr]   =   feq(ρ_avg, w[kk], c[:, kk], u_avg);
        end
        push!(cells_to_redist_to, (i_nbr, j_nbr));
        counter +=  1;
      end
    end # end reflag neighbors loop

    # redistribute mass amoung valid neighbors
    const mex = m[i, j] - ρ[i, j];
    for node in cells_to_redist_to
      const ii, jj      =   node.val;
      m[ii, jj]        +=   mex; 
    end
    m[i, j]   = ρ[i, j]; # set mass to local ρ
  end

  for node in new_empty_cells # convert emptied cells to gas cells
    const i, j      =     node.val;
    states[i, j]    =     GAS;

    cells_to_redist_to  =   DoublyLinkedList{Tuple{Int, Int}}();
    counter::UInt       =   0;
    for k=1:nk-1
      const i_nbr     =     i + c[1, k];
      const j_nbr     =     j + c[2, k];

      if (i_nbr >= 1 && i_nbr <= ni && j_nbr >= 1 && j_nbr <= nj &&
          states[i_nbr, j_nbr] == FLUID)
        states[i_nbr, j_nbr] =  INTERFACE;
        counter             +=  1;
        push!(cells_to_redist_to, (i_nbr, j_nbr));
      end
    end

    for nodenode in cells_to_redist_to # redistribute excess mass
      const ii, jj  =   nodenode.val;
      m[ii, jj]    +=   m[i, j] / counter;
    end

    m[i, j]   =   0.0;
    ϵ[i, j]   =   0.0;
  end

  # Redistribute excess mass
  for node in new_fluid_cells # Redistribute excess mass from new fluid cells
    const i, j      =     node.val;
    
    cells_to_redist_to  =     DoublyLinkedList{Tuple{Int, Int}}();
    counter::UInt       =     0;

    # Construct interface cells from neighborhood average at equilibrium
    for k=1:nk-1
      const i_nbr     =     i + c[1, k];
      const j_nbr     =     j + c[2, k];

      if (i_nbr >= 1 && i_nbr <= ni && j_nbr >= 1 && j_nbr <= nj &&
          states[i_nbr, j_nbr] == INTERFACE)
        push!(cells_to_redist_to, (i_nbr, j_nbr));
        counter +=  1;
      end
    end # find inteface loop

    # redistribute mass amoung valid neighbors
    const mex = m[i, j] - ρ[i, j];
    for node in cells_to_redist_to
      const ii, jj      =   node.val;
      m[ii, jj]        +=   mex; 
      ϵ[ii, jj]         =   m[ii, jj] / ρ[ii, jj];
    end

    m[i, j]   = ρ[i, j]; # set mass to local ρ
    ϵ[i, j]   = 1.0;
  end

  for node in new_empty_cells # Redistribute excess mass from emptied cells
    const i, j      =     node.val;
    
    cells_to_redist_to  =     DoublyLinkedList{Tuple{Int, Int}}();
    counter::UInt       =     0;

    # Construct interface cells from neighborhood average at equilibrium
    for k=1:nk-1
      const i_nbr     =     i + c[1, k];
      const j_nbr     =     j + c[2, k];

      if (i_nbr >= 1 && i_nbr <= ni && j_nbr >= 1 && j_nbr <= nj &&
          states[i_nbr, j_nbr] == INTERFACE)
        push!(cells_to_redist_to, (i_nbr, j_nbr));
        counter +=  1;
      end
    end # find inteface loop

    # redistribute mass amoung valid neighbors
    const mex = m[i, j];
    for node in cells_to_redist_to
      const ii, jj      =   node.val;
      m[ii, jj]        +=   mex;
      ϵ[ii, jj]         =   m[ii, jj] / ρ[ii, jj];
    end

    m[i, j]   = 0.0;
    ϵ[i, j]   = 0.0;
  end
end

# Main function
function _main()
  const   nx::UInt      =     256;
  const   ny::UInt      =     256;

  const   nu            =     0.2;                # viscosity
  const   ω             =     1.0 / (nu + 0.5);   # collision frequency
  const   ρ_0           =     1.0;                # reference density
  const   ρ_A           =     1.0;                # atmosphere pressure
  const   g             =     [0.0; -1.0];        # gravitation acceleration

  const   κ             =     1.0e-3;             # state change (mass) offset
  
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
    reconstruct_from_empty!(f, w, c, u, ϵ, states, ρ_A);

    # reconstruct DFs along interface normal
    reconstruct_from_normal!(f, w, c, u, ϵ, states, ρ_A);

    # perform collision
    collide!(f, w, c, ρ, u, ω, ϵ, states, g);

    # boundary conditions
    boundary_conditions!(f, states);

    # calculate macroscopic variables
    map_to_macro!(f, c, ρ, u);

    # update fluid fraction
    elst, flst = update_fluid_fraction!(ρ, ϵ, m, states, κ);

    # update cell states
    @debug_mass_cons(
      update_cell_states!(f, c, w, ρ, u, ϵ, m, states, elst, flst),
      "update cell states",
      m);

    # process
    if step % 25 == 0
      clf();
      cs = contourf(transpose(m), levels=[0.0, 0.25, 0.5, 0.75, 1.0]);
      colorbar(cs);
      draw();
      pause(0.001);
    end
  end

end

_main();
