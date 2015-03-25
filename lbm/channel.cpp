#include <armadillo>
#include <iomanip>
#include <iostream>
#include <array>

using namespace arma;
using namespace std;

int main(int argc, char* argv[])
{
    /* domain */
    const double width = 100.;
    const double height = 40.;
    const int n_x = 1000;
    const int n_y = 40;
    const double dx = width/n_x;
    const double dy = height/n_y;
    const double dt = 1.;
    const int n_dir = 9;
    
    /* init data */
    mat rho(n_x+1,n_y+1);
    mat u(n_x+1,n_y+1);
    mat v(n_x+1,n_y+1);
    array<mat,n_dir> f;
    const double alpha = 0.02;
    const double c_k = dx/dt;
    const double c_sq = c_k*c_k;
    const double omega = 1./(3.*alpha/(c_sq*dt)+0.5); /*!< collision freq */
    const int num_tsteps = 40000;
    const array<double,n_dir> w { 4./9., 1./9., 1./9., 1./9., 1./9., 1./36., 1./36.,
        1./36., 1./36. };
    const array<int,n_dir> c_x { 0, 1, 0, -1, 0, 1, -1, -1, 1 };
    const array<int,n_dir> c_y { 0, 0, 1, 0, -1, 1, 1, -1, -1 };
    
    /* initial conditions */
    const double u_o = 0.2;
    const double rho_o = 5.;
    const double Re = u_o*n_y / alpha;
    u.zeros();
    v.zeros();
    for (auto j = 0; j < n_y; ++j) u(0,j) = u_o; /*!< set velocity at inlet */
    rho.fill(rho_o);
    for (auto k = 0; k < n_dir; ++k)
    {
        f[k] = mat(n_x+1,n_y+1);
        for (auto i = 0; i <= n_x; ++i)
            for (auto j = 0; j <= n_y; ++j)
                f[k](i,j) = w[k]*rho(i,j);
    }
    
    cout << setw(20) << "lattices in x-dir = " << n_x << endl
         << setw(20) << "lattices in y-dir = " << n_y << endl
         << setw(20) << "alpha = " << alpha << endl
         << setw(20) << "u at inlet = " << u_o << endl
         << setw(20) << "Re = " << Re << endl;
    
    const auto report = 25;
    
    /* main loop */
    for (auto tstep = 1; tstep <= num_tsteps; ++tstep)
    {  
        if (tstep % report == 0) cout << tstep << endl;
    
        /* collision */
        for (auto i = 0; i <= n_x; ++i)
            for (auto j = 0; j <= n_y; ++j)
            {
                double u_sq = u(i,j)*u(i,j) + v(i,j)*v(i,j); /*!< u dot u */
                for (auto k = 0; k < n_dir; ++k)
                {
                    double u_dot_c = u(i,j)*c_x[k] + v(i,j)*c_y[k]; /*!< u dot c */
                    double f_eq = w[k]*rho(i,j)* (1.0 + 3.0*u_dot_c +
                        4.5*u_dot_c*u_dot_c - 1.5*u_sq);
                    f[k](i,j) = omega*f_eq + (1.-omega)*f[k](i,j);
                }
            }
                
        /* streaming */
        for (auto j = 0; j <= n_y; ++j) /* horizontals */
        {
            for (auto i = n_x; i > 0; --i) f[1](i,j) = f[1](i-1,j);
            for (auto i = 0; i < n_x; ++i) f[3](i,j) = f[3](i+1,j);
        }
        
        for (auto j = n_y; j > 0; --j) /* top to bottom */
        {
            for (auto i = 0; i <= n_x; ++i) f[2](i,j) = f[2](i,j-1);
            for (auto i = n_x; i > 0; --i) f[5](i,j) = f[5](i-1,j-1);
            for (auto i = 0; i < n_x; ++i) f[6](i,j) = f[6](i+1,j-1);
        }
        
        for (auto j = 0; j < n_y; ++j) /* bottom to top */
        {
            for (auto i = 0; i <= n_x; ++i) f[4](i,j) = f[4](i,j+1);
            for (auto i = 0; i < n_x; ++i) f[7](i,j) = f[7](i+1,j+1);
            for (auto i = n_x; i > 0; --i) f[8](i,j) = f[8](i-1,j+1);
        }
            
        /* boundary conditions */
        for (auto j = 0; j <= n_y; ++j) /* west inlet */
        {
            double rhow = (f[0](0,j) + f[2](0,j) + f[4](0,j) +
                2. * (f[3](0,j) + f[6](0,j) + f[7](0,j))) / (1.-u_o);
            f[1](0,j) = f[3](0,j) + 2.*rhow*u_o/3.;
            f[5](0,j) = f[7](0,j) + rhow*u_o/6.;
            f[8](0,j) = f[6](0,j) + rhow*u_o/6.;
        }
        
        for (auto i = 0; i <= n_x; ++i) /* south bc bounce back */
        {
            f[2](i,0) = f[4](i,0);
            f[5](i,0) = f[7](i,0);
            f[6](i,0) = f[8](i,0);
        }
        
        for (auto i = 1; i < n_x; ++i) /* north bc bounce back */
        {
            f[4](i,n_y) = f[2](i,n_y);
            f[8](i,n_y) = f[6](i,n_y);
            f[7](i,n_y) = f[5](i,n_y);
        }
        
        for (auto j = 1; j <= n_y; ++j) /* east open */
        {
            f[1](n_x,j) = 2.0*f[1](n_x-1,j) - f[1](n_x-2,j);
            f[5](n_x,j) = 2.0*f[5](n_x-1,j) - f[5](n_x-2,j);
            f[8](n_x,j) = 2.0*f[8](n_x-1,j) - f[8](n_x-2,j);
        }
        
        /* calculate macroscopic density */
        for (auto j = 0; j < n_y; ++j)
            for (auto i = 0; i <= n_x; ++i)
            {
                double sum = 0.;
                for (auto k = 0; k < n_dir; ++k) sum += f[k](i,j);
                rho(i,j) = sum;
            }
            
        /* calculate macroscopic flow velocity */
        for (auto i = 1; i <= n_x; ++i)
            for (auto j = 1; j < n_y; ++j)
            {
                double usum = 0., vsum = 0.;
                for (auto k = 0; k < n_dir; ++k)
                {
                    usum += f[k](i,j)*c_x[k];
                    vsum += f[k](i,j)*c_y[k];
                }
                u(i,j) = usum/rho(i,j); /*!< momentum is sum f dot c */
                v(i,j) = vsum/rho(i,j);
            }
            
        /* this is necessary because at the outlet, we assume that y-component
         * velocity (v) should be zero. This is a rational assumption if we do
         * not know the outlet boundary condition.
         */
        for (auto j = 1; j <= n_y; j++) v(n_x,j) = 0.;
    }
    
    ofstream outfile;
    outfile.open("channel.csv", ofstream::out);
    cout << "Writing to channel.csv ... " << endl;
       
    /* output data */
    outfile << "x,y,rho,u,v" << endl;
    for (auto i = 0; i <= n_x; ++i)
        for (auto j = 0; j <= n_y; ++j)
            outfile << dx*i << "," << dy*j << "," << rho(i,j) << "," << u(i,j)
                    << "," << v(i,j) << endl;
    cout << "... finished." << endl;
    outfile.close();
    
    return 0;
}
