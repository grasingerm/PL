module PhysicalConstants
  const c = 299792458;
  const h = 6.62607004e-34;
  const hbar = 6.62607004e-34 / (2 * π);
  const G = 6.674e-11;
  const g = 9.807;

  # thermodynamics
  const kB = 1.38064852e-23;
  const NA = 6.0221409e23;
  const R = kB * NA;

  # electromagnetics
  const ϵ0 = 8.854187817e-12;
  const μ0 = 4 * π * 1e-7;
  const Z0 = μ0 * c;
  const ke = 1 / 4.0 * π * ϵ0;
  const eC = 1.602176565e-19;
  const ϕ0 = h / (2 * eC);

  # masses of elementary particles
  const me = 9.10938291e-31;
  const mp = 1.672621777e-27;
  const mn = 1.674927471e-27;

  const F = NA * eC;
  const atm = 101325;
end
