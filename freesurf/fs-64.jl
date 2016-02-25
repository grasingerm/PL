using PyPlot;
using List;
using Logging;

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

function reset_logging_to_default()
  Logging.configure(level=WARNING);
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
    f[k, i, j]      =   ρ_0 * w[k];
  end

  map_to_macro!(f, c, ρ, u);

  for j=1:fill_nj, i=1:fill_ni
    m[i, j]      =   ρ[i, j];
    ϵ[i, j]      =   1.0;
    states[i, j] =   FLUID;
  end

  for j=1:fill_nj
    const i     =   fill_ni + 1;

    m[i, j]      =   ρ[i, j] / 2.0;
    ϵ[i, j]      =   0.5;
    states[i, j] =   INTERFACE;
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

  dm              =     zeros(nk, ni, nj);

  for j=1:nj, i=1:ni
    if states[i,j] != GAS
      for k=1:nk-1
        const i_nbr   =   i + c[1,k];
        const j_nbr   =   j + c[2,k];

        if (i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj ||
            states[i_nbr, j_nbr] == GAS) # if out of bounds or at a gas cell
            dm[k, i, j] = 0.0;
          continue;
        end

        const opp_k   =   _opp_k(k);

        if ((states[i, j] == FLUID && states[i_nbr, j_nbr] == FLUID)      ||
            (states[i, j] == FLUID && states[i_nbr, j_nbr] == INTERFACE)  ||
            (states[i, j] == INTERFACE && states[i_nbr, j_nbr] == FLUID))
          dm[k, i, j]      =  f[opp_k, i_nbr, j_nbr] - f[k, i, j];
          m[i,j]          +=  dm[k, i, j];
        elseif states[i, j] == INTERFACE && states[i_nbr, j_nbr] == INTERFACE
          dm[k, i, j]      =  (0.5 * (ϵ[i_nbr, j_nbr] + ϵ[i, j]) * 
                               (f[opp_k, i_nbr, j_nbr] - f[k, i, j]));
          m[i, j]         +=  dm[k, i, j];
        else
          error("State $(states[i_nbr, j_nbr]), not understood");
        end

      end # for each neighbor
    else
      dm[:, i, j] = 0.0;
    end # only transfer mass across interface cells
  end # for each node

  for j=1:nj, i=1:ni, k=1:nk
    const i_nbr   =   i + c[1,k];
    const j_nbr   =   j + c[2,k];


    if (i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj ||
        states[i_nbr, j_nbr] == GAS) # if out of bounds or at a gas cell
      @assert(dm[k, i, j] == 0.0, 
              "Should not be transfering mass out of bounds/into gas");
      continue;
    end

    @assert(abs(dm[k, i, j] + dm[_opp_k(k), i_nbr, j_nbr]) < 1e-12, 
            "Changes in mass should be symmetrical, " * 
            "($k, $i, $j) != -($(_opp_k(k)), $i_nbr, $j_nbr) => " *
            "$(dm[k, i, j]) != $(-dm[_opp_k(k), i_nbr, j_nbr])"   *
            "($i, $j) is $(states[i, j]) with ϵ = $(ϵ[i, j]), "   *
            "($i_nbr, $j_nbr) is $(states[i_nbr, j_nbr]) with "   *
            "ϵ = $(ϵ[i_nbr, j_nbr])");
  end

  @assert(abs(sum(dm)) < 1e-9, "Mass should be conserved");
end

# stream particle distribution functions
function stream!(f::Array{Float64, 3}, c::Matrix{Int64}, states::Matrix{State})
  const ni, nj  =   size(states);
  const nk      =   size(c, 2);

  f_new         =   copy(f);
  
  for j=1:nj, i=1:ni
    if states[i, j] != GAS
      for k=1:nk-1
        const i_nbr   =   i + c[1,k];
        const j_nbr   =   j + c[2,k];

        if (i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj ||
            states[i_nbr, j_nbr] == GAS) # if out of bounds or at a gas cell
          continue;
        end

        f_new[k, i_nbr, j_nbr] = f[k, i, j];
      end
    end
  end

  copy!(f, f_new);
end

#! equilibrium distribution function
function feq(ρ_ij::Real, w_k::Real, c_k::Vector{Int64}, u_ij::Vector{Float64})
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

    const n_int     =   1/2 * Float64[ϵ_il - ϵ_ir; ϵ_jd - ϵ_ju];
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
function boundary_conditions!(f::Array{Float64, 3}, states::Matrix{State},
                              m::Matrix{Float64})
  const ni, nj  = size(states);

  for i=1:ni
    if states[i, 1]   != GAS
      # south wall
      for (k1, k2) in zip((2, 5, 6),(4, 7, 8))
        f[k1, i, 1]   =   f[k2, i, 1];
      end
    end

    if states[i, nj]  != GAS
      # north wall
      for (k1, k2) in zip((4, 7, 8),(2, 5, 6)) 
        f[k1, i, nj]   =   f[k2, i, nj];
      end
    end
  end

  for j=1:nj
    if states[1, j]   != GAS 
      # west wall
      for (k1, k2) in zip((1, 5, 8),(3, 7, 6)) 
        m0 = m[1, j];
        f[k1, 1, j]   =   f[k2, 1, j];
      end
    end

    if states[ni, j]  != GAS
      # north wall
      for (k1, k2) in zip((3, 7, 6),(1, 5, 8)) 
        f[k1, ni, j]   =   f[k2, ni, j];
      end
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
    ϵ[i, j] = m[i, j] / ρ[i, j];

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
                             w::Vector{Float64}, ρ::Matrix{Float64}, 
                             u::Array{Float64, 3}, ϵ::Matrix{Float64}, 
                             m::Matrix{Float64}, states::Matrix{State},
                             new_empty_cells::DoublyLinkedList{Tuple{Int, Int}},
                             new_fluid_cells::DoublyLinkedList{Tuple{Int, Int}})
  #Logging.configure(level=DEBUG);
  const ni, nj  = size(states);
  const nk      = size(c, 2);
 
  debug("Preparing neighborhood of all cells flagged for fluidizing");
  for node in new_fluid_cells # First the neighborhood of all filled cells are prepared
    const i, j      =     node.val;
    debug("Converting state($i, $j) = $(states[i, j]) -> $(FLUID)");
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
    debug("ρ_avg = $(ρ_avg), u_avg = $u_avg, with $counter valid neighbors");

    # Construct interface cells from neighborhood average at equilibrium
    for k=1:nk-1
      const i_nbr     =     i + c[1, k];
      const j_nbr     =     j + c[2, k];

      if i_nbr < 1 || i_nbr > ni || j_nbr < 1 || j_nbr > nj
        continue;
      end

      # If it is already an interface cell, make sure it is not emptied
      if states[i_nbr, j_nbr] == INTERFACE
        debug("Checking to ensure ($i_nbr, $j_nbr) is not emptied.");
        remove!(new_empty_cells, (i_nbr, j_nbr));
      elseif states[i_nbr, j_nbr] == GAS
        debug("Converting state($i_nbr, $j_nbr) = $(states[i_nbr, j_nbr]) -> $(INTERFACE)");
        states[i_nbr, j_nbr] = INTERFACE;
        for kk=1:nk
          f[kk, i_nbr, j_nbr]   =   feq(ρ_avg, w[kk], c[:, kk], u_avg);
        end
      end
    end # end reflag neighbors loop
  end

  debug("Convert emptied cells to gas cells");
  for node in new_empty_cells # convert emptied cells to gas cells
    const i, j      =     node.val;
    debug("Converting state($i, $j) = $(states[i, j]) -> $(GAS)");
    states[i, j]    =     GAS;

    for k=1:nk-1
      const i_nbr     =     i + c[1, k];
      const j_nbr     =     j + c[2, k];

      if (i_nbr >= 1 && i_nbr <= ni && j_nbr >= 1 && j_nbr <= nj &&
          states[i_nbr, j_nbr] == FLUID)
        debug("Converting state($i_nbr, $j_nbr) = $(states[i_nbr, j_nbr]) -> $(INTERFACE)");
        states[i_nbr, j_nbr] =  INTERFACE;
      end
    end
  end

  # Redistribute excess mass
  debug("Redistribute excess mass from filled cells");
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
      debug("Redistributing mass from ($i, $j) -> ($ii, $jj)");
      m[ii, jj]        +=   mex; 
      ϵ[ii, jj]         =   m[ii, jj] / ρ[ii, jj];
    end

    m[i, j]   = ρ[i, j]; # set mass to local ρ
    ϵ[i, j]   = 1.0;
  end

  debug("Redistribute excess mass from empty cells");
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
      debug("Redistributing mass from ($i, $j) -> ($ii, $jj)");
      m[ii, jj]        +=   mex;
      ϵ[ii, jj]         =   m[ii, jj] / ρ[ii, jj];
    end

    m[i, j]   = 0.0;
    ϵ[i, j]   = 0.0;
  end

  reset_logging_to_default();
end

# Main function
function _main()
  reset_logging_to_default();

  const   nx::UInt      =     64;
  const   ny::UInt      =     64;

  const   nu            =     0.2;                # viscosity
  const   ω             =     1.0 / (nu + 0.5);   # collision frequency
  const   ρ_0           =     1.0;                # reference density
  const   ρ_A           =     1.0;                # atmosphere pressure
  const   g             =     [0.0; -1.0e-6];     # gravitation acceleration

  const   κ             =     1.0e-3;             # state change (mass) offset
  
  const   nsteps::UInt  =     10000000;

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
  
  println("Initial mass: ", sum(m));
  println();
  println("Starting simulation...");

  # iterate through time steps
  for step=0:nsteps # start at zero so we can have a figure of the initial conditions
    init_mass   =   sum(m);

    # process
    if step % 250 == 0
      clf();
      cs = contourf(transpose(m), levels=[-0.25, 0.0, 0.25, 0.5, 0.75, 1.0, 1.25]);
      colorbar(cs);
      #draw();
      savefig(joinpath("//", "run", "media", "clementine", "4123031432", "freesurf", "figs-32",@sprintf("mass_step-%09d.png", step)));
      #pause(0.001);
      println("step: ", step);
    end
    
    # mass transfer
    println("Transfering mass...");
    im1 = sum(m);
    masstransfer!(f, c, ϵ, m, states);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im1) < 1e-13
      println("dm -> ", sum(m) - im1);
    else
      warn("dm -> $(sum(m) - im1)");
    end

    # stream
    println("Streaming...");
    im1 = sum(m);
    stream!(f, c, states);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im1) < 1e-13
      debug("dm -> ", sum(m) - im1);
    else
      warn("dm -> $(sum(m) - im1)");
    end

    println("Reconstructing DFs...");
    im1 = sum(m);
    # reconstruct DFs from empty cells
    reconstruct_from_empty!(f, w, c, u, ϵ, states, ρ_A);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im1) < 1e-13
      debug("dm -> ", sum(m) - im1);
    else
      warn("dm -> $(sum(m) - im1)");
    end

    # reconstruct DFs along interface normal
    reconstruct_from_normal!(f, w, c, u, ϵ, states, ρ_A);
    im1 = sum(m);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im1) < 1e-13
      debug("dm -> ", sum(m) - im1);
    else
      warn("dm -> $(sum(m) - im1)");
    end

    # perform collision
    println("Performing collisions...");
    im1 = sum(m);
    collide!(f, w, c, ρ, u, ω, ϵ, states, g);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im1) < 1e-13
      debug("dm -> ", sum(m) - im1);
    else
      warn("dm -> $(sum(m) - im1)");
    end

    # boundary conditions
    println("Enforcing boundary conditions...");
    im1 = sum(m);
    boundary_conditions!(f, states, m);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im1) < 1e-13
      debug("dm -> ", sum(m) - im1);
    else
      warn("dm -> $(sum(m) - im1)");
    end

    # calculate macroscopic variables
    println("Calculating macroscopic variables...");
    im1 = sum(m);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im1) < 1e-13
      debug("dm -> ", sum(m) - im1);
    else
      warn("dm -> $(sum(m) - im1)");
    end

    # update fluid fraction
    println("Updating fluid fractions...");
    im1 = sum(m);
    elst, flst = update_fluid_fraction!(ρ, ϵ, m, states, κ);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im1) < 1e-13
      debug("dm -> ", sum(m) - im1);
    else
      warn("dm -> $(sum(m) - im1)");
    end

    # update cell states
    #=@debug_mass_cons(
      update_cell_states!(f, c, w, ρ, u, ϵ, m, states, elst, flst),
      "update cell states",
      m);=#
    println("Updating cell states...");
    im2 = sum(m);
    update_cell_states!(f, c, w, ρ, u, ϵ, m, states, elst, flst);
    map_to_macro!(f, c, ρ, u);
    if abs(sum(m) - im2) < 1e-13
      debug("dm -> ", sum(m) - im2);
    else
      warn("dm -> $(sum(m) - im2)");
    end

    println("Testing conditions...");
    #=for j=1:ny, i=1:nx
      if states[i, j] == FLUID
        @assert(ϵ[i, j] == 1.0, 
                "Fluid fraction should be 1.0 at fluid cells ($i, $j). " *
                "ϵ($i, $j) != 1.0; $(ϵ[i, j]) != 1.0.");
        @assert(abs(m[i, j] - ρ[i, j]) < 1e-9, 
                "Mass should equal density at fluid cells ($i, $j). "    *
                "m($i, $j) != ρ($i, $j); $(m[i, j]) != $(ρ[i, j]).");
      elseif states[i, j] == INTERFACE
        @assert(ϵ[i, j] == m[i, j] / ρ[i, j], 
                "Fluid fraction should be mass over ρ at interface cells ($i, $j). " *
                "ϵ($i, $j) != m($i, $j) / ρ($i, $j); " *
                "$(ϵ[i, j]) != $(m[i, j]) / $(ρ[i, j]).");
      end
    end=#

    println("End step.");
    @show sum(m) - init_mass;
    println();
  end

end

_main();
