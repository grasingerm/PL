using FastAnonymous;

abstract Point;
type Point2D <: Point
  x::Real;
  y::Real;
end
type Point3D <: Point
  x::Real;
  y::Real;
  z::Real;
end
r(p::Point2D, q::Point2D) = sqrt((p.x - q.x)^2 + (p.y - q.y)^2);
r(p::Point3D, q::Point3D) = sqrt((p.x - q.x)^2 + (p.y - q.y)^2 + (p.z - q.z)^2);
rv(p::Point2D, q::Point2D) = [q.x - p.x, q.y - p.y];
rv(p::Point3D, q::Point3D) = [q.x - p.x, q.y - p.y, q.z - p.z];

#! Calculate a simplified Lennard-Jones potential
#!
#! \param   A   
#! \param   B
#! \param   r     Distance between the two particles
function vslj(A::Real, B::Real, r::Real)
  const r6 = r^6;
  return A / (r6 * r6) - B / r6;
end

#! Calculate a simplified Lennard-Jones potential
#!
#! \param   ϵ     Well depth   
#! \param   σ     Distance at which intermolecular potential is zero
#! \param   r     Distance between the two particles
function vlj(ϵ::Real, σ::Real, r::Real)
  σr6 = (σ / r)^6;
  return 4 * ϵ * (σr6^2 - σr6);
end

abstract Molecule;

type Argon <: Molecule
  m::Real;
  pos::Point;
end

ϵ(a::Argon, b::Argon)   =   0.997;
σ(a::Argon, b::Argon)   =   3.4;

function vlj(m1::Molecule, m2::Molecule)
  return vlj(ϵ(m1, m2), σ(m1, m2), r(m1.pos, m2.pos));
end

function md(ms::Vector{Molecule}, nsteps::Int, Δt::Real)
  nm = length(ms);
  for k=1:nsteps
    for i=1:nm
      f = zeros(2); 
      for j=1:i-1
        f += vlj(ms[i], ms[j]) * rv(ms[i].pos, ms[j].pos);
      end
      for j=i+1:nm
        f += vlj(ms[i], ms[j]) * rv(ms[i].pos, ms[j].pos);
      end
    end
  end
end
