#include <cassert>
#include <cstdio>
#include <cstring>
#include <string>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <boost/lexical_cast.hpp>
#include <exception>

using namespace std;

void PrettyFormat(int i, char* buf)
{
  sprintf(buf, "%4d", i);
}

void PrettyFormat(int i, char* buf, int buflen)
{
  snprintf(buf, buflen, "%4d", i); 
}

template <typename T>
void PrettyFormat(T val, string& s)
{
  ostringstream temp;
  temp << setw(4) << val;
  s = temp.str();
}

template <typename T>
void BoostPrettyFormat(T val, string& s)
{
  s = boost::lexical_cast<string>(val);
}

template<typename Target, typename Source>
Target my_lexical_cast(Source arg)
{
  std::stringstream interpreter;
  Target result;

  if (!(interpreter << arg) || !(interpreter >> result) || 
      !(interpreter >> std::ws).eof())
    throw std::runtime_error("shit");

  return result;
}

template <typename T>
void MyPrettyFormat(T val, string& s)
{
  s = my_lexical_cast<string>(val);
}

int main()
{
  char small_buff[5];
  int val = 42;
  PrettyFormat(val, small_buff);
  printf("PrettyFormat(sprintf) -> %s\n", small_buff);
  assert(val == 42);

  val = 12108642;
  PrettyFormat(val, small_buff);
  printf("PrettyFormat(sprintf) -> %s\n", small_buff);
  // assert(val == 12108642); NOTE: this will probably fail and/or crash

  val = 42;
  PrettyFormat(val, small_buff, 5);
  printf("PrettyFormat(snprintf) -> %s\n", small_buff);
  assert(val == 42);

  val = 12108642;
  PrettyFormat(val, small_buff, 5);
  printf("PrettyFormat(snprintf) -> %s\n", small_buff);
  assert(val == 12108642);

  string s;
  val = 42;
  PrettyFormat(val, s);
  cout << "PrettyFormat(ostringstream) -> " << s << "\n";
  assert(val == 42);

  val = 12108642;
  PrettyFormat(val, s);
  cout << "PrettyFormat(ostringstream) -> " << s << "\n";
  assert(val == 12108642);

  val = 42;
  BoostPrettyFormat(val, s);
  cout << "BoostPrettyFormat -> " << s << "\n";
  assert(val == 42);

  val = 12108642;
  BoostPrettyFormat(val, s);
  cout << "BoostPrettyFormat -> " << s << "\n";
  assert(val == 12108642);

  val = 42;
  MyPrettyFormat(val, s);
  cout << "MyPrettyFormat -> " << s << "\n";
  assert(val == 42);

  val = 12108642;
  MyPrettyFormat(val, s);
  cout << "MyPrettyFormat -> " << s << "\n";
  assert(val == 12108642);

  return 0;
}
