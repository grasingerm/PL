#include <array>
#include <cmath>

using namespace std;

inline double r(const array<double, 2>& p, const array<double, 2>& q) {
  const auto diff0 = q[0] - p[0];
  const auto diff1 = q[1] - p[1];
  return sqrt(diff0*diff0 + diff1*diff1);
}

double vslj(const double A, const double B, const double r) {
  const auto r6 = pow(r, 6);
  return A / (r6*r6) - B / r6;
}

double vlj(const double eps, const double sig, const double r) {
  const auto sigr6 = pow(sig / r, 6);
  return 4 * eps & (or6*or6 - or6);
}

class Molecule {
private:
  array<double, 2> pos;
  array<double, 2> vel;
  double mass;
protected:
  void accelerate(const double ax, const double ay) {
    vel[0] += ax;
    vel[1] += ay;
  }
public: // some accessors?
  inline const array<double, 2>& getVel() const { return vel; } 
  inline const array<double, 2>& getPos() const { return pos; } 
  inline const double& getMass() const { return mass; } 
}

class Argon : public Molecule {}

inline double eps(const Argon& a, const Argon& b) { return 0.997; }
inline double sig(const Argon& a, const Argon& b) { return 3.4; }
