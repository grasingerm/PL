#include <iostream>
#include <array>
#include <functional>

using namespace std;

std::array<double, 1> _gp1 { 0.0 };
std::array<double, 2> _gp2 { -0.5773502691896257, 0.5773502691896257 };
std::array<double, 3> _gp3 { -0.7745966692414834, 0.0, 0.7745966692414834 };

std::array<double, 1> _gw1 { 2.0 };
std::array<double, 2> _gw2 { 1.0, 1.0 };
std::array<double, 3> _gw3 { 5.0 / 9.0, 8.0 / 9.0, 5.0 / 9.0 };

template <typename result, typename ...sig> gauss_quadrature( 
