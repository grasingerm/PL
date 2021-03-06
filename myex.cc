#include <iostream>
#include <exception>

using namespace std;

class myexception : public exception
{
  virtual const char* what() const throw()
  {
    return "My exception happend";
  }
} myex;

int main ()
{
  try
  {
    throw myex;
  }
  catch (exception& e)
  {
    cout << e.what() << '\n';
  }

  try
  {
    throw myex;
  }
  catch(...){}
  
  return 0;
}
