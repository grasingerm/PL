#include <armadillo>
#include <iomanip>
#include <iostream>
#include <array>

using namespace arma;
using namespace std;

int main()
{
    /* domain */
    const double width = 100.;
    const double height = 100.;
    const int n_x = 100;
    const int n_y = 100;
    const double dx = width/n_x;
    const double dy = height/n_y;
    const double dt = 1.;
    const int n_dir = 9;
    
    /* init data */
    mat rho(n_x+1,n_y+1);
    mat u(n_x+1,n_y+1);
    mat v(n_x+1,n_y+1);
    array<mat,n_dir> f;
    const double alpha = 0.01;
    const double c_k = dx/dt;
    const double c_sq = c_k*c_k;
    const double omega = 1./(3.*alpha/(c_sq*dt)+0.5); /*!< collision freq */
    const int num_tsteps = 40000;
    const array<double,n_dir> w {{ 4./9., 1./9., 1./9., 1./9., 1./9., 1./36., 1./36.,
        1./36., 1./36. }};
    const array<int,n_dir> c_x {{ 0, 1, 0, -1, 0, 1, -1, -1, 1 }};
    const array<int,n_dir> c_y {{ 0, 0, 1, 0, -1, 1, 1, -1, -1 }};
    
    /* initial conditions */
    const double u_o = 0.1;
    const double rho_o = 5.;
    const double Re = u_o*n_y / alpha;
    /* lattice Reynold's number must match physical Reynold's number. For
     * the physical problem the Re = U_lid * H/v = 6 m/s * 0.2 m / 0.00012 m^2/s
     * = 1,000. NOTE: we are free to use any values for U_lid and viscosity
     * provided that Re = 1000. Therefor flow velocity and alpha depend on 
     * number of lattice nodes and vice versa
     */
    u.zeros();
    v.zeros();
    for (auto i = 1; i < n_x; i++) u(i,n_y) = u_o; /*!< lid driven cavity */
    rho.fill(rho_o);
    for (auto k = 0; k < n_dir; k++)
    {
        f[k] = mat(n_x+1,n_y+1);
        for (auto i = 0; i <= n_x; i++)
            for (auto j = 0; j <= n_y; j++)
                f[k](i,j) = w[k]*rho(i,j);
    }
    
    cout << setw(20) << "lattices in x-dir = " << n_x << endl
         << setw(20) << "lattices in y-dir = " << n_y << endl
         << setw(20) << "alpha = " << alpha << endl
         << setw(20) << "u at lid = " << u_o << endl
         << setw(20) << "Re = " << Re << endl;
    
    const auto report = 25;
    
    /* main loop */
    for (auto tstep = 1; tstep <= num_tsteps; ++tstep)
    {  
        if (tstep % report == 0) cout << tstep << endl;
    
        /* collision */
        for (auto i = 0; i <= n_x; i++)
            for (auto j = 0; j <= n_y; j++)
            {
                double u_sq = u(i,j)*u(i,j) + v(i,j)*v(i,j); /*!< u dot u */
                for (auto k = 0; k < n_dir; k++)
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
        
        for (auto j = n_y; j > 0; j--) /* top to bottom */
        {
            for (auto i = 0; i <= n_x; ++i) f[2](i,j) = f[2](i,j-1);
            for (auto i = n_x; i > 0; --i) f[5](i,j) = f[5](i-1,j-1);
            for (auto i = 0; i < n_x; ++i) f[6](i,j) = f[6](i+1,j-1);
        }
        
        for (auto j = 0; j < n_y; j++) /* bottom to top */
        {
            for (auto i = 0; i <= n_x; ++i) f[4](i,j) = f[4](i,j+1);
            for (auto i = 0; i < n_x; ++i) f[7](i,j) = f[7](i+1,j+1);
            for (auto i = n_x; i > 0; --i) f[8](i,j) = f[8](i-1,j+1);
        }
            
        /* boundary conditions */
        for (auto j = 0; j <= n_y; ++j) /* west bc bounce back */
        {
            f[1](0,j) = f[3](0,j);
            f[5](0,j) = f[6](0,j);
            f[8](0,j) = f[7](0,j);
        }
        
        for (auto j = 0; j <= n_y; ++j) /* east bc bounce back */
        {
            f[6](n_x,j) = f[8](n_x,j);
            f[3](n_x,j) = f[1](n_x,j);
            f[7](n_x,j) = f[5](n_x,j);
        }
        
        for (auto i = 0; i <= n_x; ++i) /* south bc bounce back */
        {
            f[2](i,0) = f[4](i,0);
            f[5](i,0) = f[7](i,0);
            f[6](i,0) = f[8](i,0);
        }
        
        for (auto i = 1; i < n_x; ++i) /* north bc, moving lid */
        {
            rho(i,n_y) = f[0](i,n_y) + f[1](i,n_y) + f[3](i,n_y) +
                2. * (f[2](i,n_y) + f[6](i,n_y) + f[5](i,n_y));
            f[4](i,n_y) = f[2](i,n_y);
            f[8](i,n_y) = f[6](i,n_y) + rho(i,n_y)*u_o/6.0;
            f[7](i,n_y) = f[5](i,n_y) - rho(i,n_y)*u_o/6.0;
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
    }
    
    ofstream outfile;
    outfile.open("lid.csv", ofstream::out);
    cout << "Writing to lid.csv ... " << endl;
       
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
