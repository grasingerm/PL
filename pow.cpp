#include <cassert>
#include <iostream>
#include <iomanip>

constexpr double pow(double x, int n)
{
    return n <= 0 ? 1 : (x * pow(x, n-1));
}

using namespace std;

int main()
{
    {
        auto ans = pow (2., 2);
        cout << setw (10) << "2^2 = " << setw (10) << ans << endl;
        assert (ans == 4);
    }
    
    {
        auto ans = pow (3., 2);
        cout << setw (10) << "3^2 = " << setw (10) << ans << endl;
        assert (ans == 9);
    }
    
    {
        auto ans = pow (4., 2);
        cout << setw (10) << "4^2 = " << setw (10) << ans << endl;
        assert (ans == 16);
    }
    
    {
        auto ans = pow (8., 2);
        cout << setw (10) << "8^2 = " << setw (10) << ans << endl;
        assert (ans == 64);
    }
    
    {
        auto ans = pow (2., 4);
        cout << setw (10) << "2^4 = " << setw (10) << ans << endl;
        assert (ans == 16);
    }
    
    {
        auto ans = pow (3., 3);
        cout << setw (10) << "3^3 = " << setw (10) << ans << endl;
        assert (ans == 27);
    }
    
    {
        auto ans = pow (4., 4);
        cout << setw (10) << "4^4 = " << setw (10) << ans << endl;
        assert (ans == 256);
    }
    
    {
        auto ans = pow(2., 10);
        cout << setw(10) << "2^10 = " << setw(10) << ans << endl;
        assert (ans == 1024);
    }
    
    {
        auto ans = pow(2., 32);
        cout << setw(10) << "2^32 = " << setw(10) << ans << endl;
        assert (ans == 4294967296);
    }
    
    return 0;
}
