#include <numeric>
#include <array>
#include <iostream>

using namespace std;

template <class InputIterator, class T>
    T my_accumulate (InputIterator first, InputIterator last, T init)
{
    while (first != last) 
    {
        init += *first;
        first++;
    }
    return init;
}

int main()
{
    array<double, 5> my_array { { 1.2, -0.3, -0.9, 5.1, 12.0 } };
    double sum;
    
    sum = accumulate(my_array.begin(), my_array.end(), 0.);
    cout << "STL accumulate: " << sum << endl;
    
    sum = accumulate(my_array.begin(), my_array.end(), 0., 
        [](double x, double y) -> double
        {
            return x + 0.1*y;
        });
    cout << "Accumulate w/ closure x+0.1y: " << sum << endl;
    
    sum = my_accumulate(my_array.begin(), my_array.end(), 0.);
    cout << "My accumulate: " << sum << endl;
    
    return 0;
}
