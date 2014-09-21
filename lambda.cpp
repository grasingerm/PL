#include <iostream>
#include <sstream>
#include <string>

using namespace std;

int main()
{
    /* write an Identity function that takes an argument and retuns the same
    argument */
    auto Identity = [](auto x) { return x; };
    
    cout << "Identity(3) = " << Identity(3) << endl;
    cout << "Identity(\"yolo\") = " << Identity("yolo") << endl;

    /* write 3 functions add, sub, and mul that take 2 params and return their
    sum, difference, and product */
    auto add = [](auto x, auto y) { return x + y; };
    auto sub = [](auto x, auto y) { return x - y; };
    auto mul = [](auto x, auto y) { return x * y; };
    
    cout << "add(3,2) = " << add(3,2) << endl;
    cout << "add(2,1.3) = " << add(2,1.3) << endl;
    cout << "sub(3,-5) = " << sub(3,-5) << endl;
    cout << "sub(1,1) = " << sub(1,1) << endl;
    cout << "mul(2,-5.3) = " << mul(2,-5.3) << endl;
    cout << "mul(9,9) = " << mul(9,9) << endl;
    
    /* write a function, identityf, that takes an argument and returns an inner
    class object that returns that argument */
    auto identityf = [](auto x)
    {
        class Inner
        {
            int x;
            public: Inner(int i): x(i) {}
            int operator() () { return x; }
        };
        return Inner(x);
    };
    
    cout << "identityf(5)() = " << identityf(5)() << endl;
    cout << "identityf(-69)() = " << identityf(-69)() << endl;
    
    /* write a function identityf, that takes an argument and returns a 
    function that returns that argument */
    auto identityfl = [](auto x)
    {
        return [=]{ return x; };
    };
    
    cout << "indentityfl(5)() = " << identityfl(5)() << endl;
    cout << "indentityfl(-69)() = " << identityfl(-69)() << endl;
    
    /* write a function that produces a function that returns values in a 
    range*/
    auto fromto = [](auto start, auto finish)
    {
        return [=]() mutable
        {
            if (start < finish)
                return start++;
            else
                throw 1;
        };
    };
    
    auto range = fromto(0, 10);
    cout << "range() = " << range() << endl;
    cout << "range() = " << range() << endl;
    cout << "range() = " << range() << endl;
    
    /* write a function that adds from two invocations */
    auto addf = [](auto x)
    {
        return [=](auto y) 
        { 
            return x+y; 
        };
    };
    
    cout << "addf(3)(5) = " << (addf(3)(5)) << endl;
    cout << "addf(1)(-1) = " << (addf(1)(-1)) << endl;
    cout << "addf(0.35)(0.11) = " << (addf(0.35)(0.11)) << endl;
    cout << "addf(8.9)(1.1) = " << (addf(8.9)(1.1)) << endl;
    
    /* write a function swap that swaps the arguments of a binary function */
    auto swap = [](auto binary)
    {
        return [=](auto x, auto y)
        {
            return binary(y,x);
        };
    };
    
    cout << "swap(sub)(3,2) = " << swap(sub)(3,2) << endl;
    
    /* write a function twice that takes a binary function and returns a unary
    function that passes its argument to the binary function twice */
    auto twice = [](auto binary)
    {
        return [=](auto x) { return binary(x,x); };
    };
    
    cout << "twice(add)(2) = " << twice(add)(2) << endl;
    cout << "twice(mul)(4.4) = " << twice(mul)(4.4) << endl;
    
    /* write a function that takes a binary function and makes it callable
    with two invocation */
    auto applyf = [](auto binary)
    {
        return [=](auto x)
        {
            return [=](auto y)
            {
                return binary(x,y);
            };
        };
    };
    
    cout << "applyf(add)(3)(4) = " << applyf(add)(3)(4) << endl;
    cout << "applyf(sub)(1)(-1) = " << applyf(sub)(1)(-1) << endl;
    
    /* write a function that takes a function and an argument and returns a
    function that takes the second argument and applies the function */
    auto curry = [](auto binary, auto x)
    {
        return [=](auto y) { return binary(x,y); };
    };
    
    cout << "curry(add,3)(-1) = " << (curry(add,3)(-1)) << endl;
    cout << "curry(sub,11)(43) = " << (curry(sub,11)(43)) << endl;
    
    auto addFour = [](auto a, auto b, auto c, auto d)
    {
        return a+b+c+d;
    };
    auto partial = [](auto func, auto a, auto b)
    {
        return [=](auto c, auto d)
        {
            return func(a, b, c, d);
        };
    };
    
    cout << "partial(addFour,1,2)(3,4) = " << partial(addFour,1,2)(3,4) 
         << endl;
         
    /* without creating a new function show 3 ways to create the inc function */
    auto inc = curry(add, 1);
    /*
    auto inc = addf(1);
    auto inc = applyf(add)(1);
    */
    
    /* write a function composeu that takes two unary functions and returns a
    unary function that calls them both */
    auto composeu = [](auto f1, auto f2)
    {
        return [=](auto x) { return f2(f1(x)); };
    };
    
    cout << "composeu(inc, curry(mul, 5))(-3) = "
         << (composeu(inc, curry(mul, 5))(-3)) << endl;
         
    /* write a function that returns a function that allows a binary function
    to be called exactly once */
    auto once = [](auto binary)
    {
        bool done = false;
        return [=](auto x, auto y) mutable
        {
            if (!done)
            {
                done = true;
                return binary(x,y);
            }
            else throw 1;
        };
    };
    
    cout << "once(add)(3,8) = " << once(add)(3,8) << endl;
    
    /* write a function that takes a binary function and returns a function
    that takes two arguments and a callback */
    
    auto binaryc = [](auto binary)
    {
        return [=](auto x, auto y, auto callback)
        {
            return callback(binary(x,y));
        };
    };
    
    cout << "binaryc(mul)(5, 6, Indentity) = " << binaryc(mul)(5, 6, Identity)
         << endl;
    cout << "binaryc(mul)(5, 6, inc) = " << binaryc(mul)(5, 6, inc) << endl;
    
    /* monads? */
    auto unit = [](auto x) { 
      return [=]() { return x; };
    };
    auto stringify = [&](auto x) {    
      std::stringstream ss;
      ss << x;
      return unit(ss.str());
    };
     
    auto bind = [](auto u) {    
      return [=](auto callback) {
       return callback(u());    
      };  
    };
    
    std::cout << "Left Identity " 
              << stringify(15)() 
              << "=="
              << bind(unit(15))(stringify)()
              << std::endl;
     
    std::cout << "Right Identity "
              << stringify(5)() 
              << "=="
              << bind(stringify(5))(unit)()
              << std::endl;
    
    return 0;
}
