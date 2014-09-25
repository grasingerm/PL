#include <iostream>

using namespace std;

int main()
{
    auto list = [](auto ...xs)
    {
        return [=](auto access) { return access(xs...); };
    };
    
    auto head = [](auto xs)
    {
        return xs([](auto first, auto ...rest) { return first; });
    };
    
    auto tail = [&list](auto xs)
    {
        return xs([&list](auto first, auto ...rest) { return list(rest...); });
    };
    
    auto length = [](auto xs)
    {
        return xs([](auto ...z) { return sizeof...(z); });
    };
    
    auto ls = list(1, 2., "3");
    int len = length(ls);
    cout << "length(list(1, '2', \"3\")) = " << len << endl;
    cout << "head(list(1, '2', \"3\")) = " << head(ls) << endl;
    cout << "head(tail(list(1, '2', \"3\")))) = " << (head(tail(ls))) << endl;
    
    auto fmap = [&list](auto func)
    {
        return [&list,&func](auto ...z) { return list(func(z)...); };
    };
    
    auto twice = [](auto i) { return 2*i; };
    auto print = [](auto i) { std::cout << i << " "; return i; };
    
    cout << "list(1,2,3,4)(fmap(twice))(fmap(print)) = ";
    list(1,2,3,4)(fmap(twice))(fmap(print));
    cout << endl;
    
    return 0;
}
