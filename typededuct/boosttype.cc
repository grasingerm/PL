#include <boost/type_index.hpp>
#include <iostream>

template<typename T> void boost_type_deducation(const T& param)
{
  using namespace std;
  using boost::typeindex::type_id_with_cvr;

  cout << "T =   "
       << type_id_with_cvr<T>().pretty_name()
       << endl;

  cout << "param =   "
       << type_id_with_cvr<decltype(param)>().pretty_name()
       << endl;
}

int main(void)
{
  using namespace std;

  const int answer = 42;

  auto x = answer;
  auto y = &answer;
  auto&& z = answer;
  const auto al = &answer;
  auto&& be = &answer;

  cout << "x:" << endl;
  boost_type_deducation(x);
  cout << endl;

  cout << "y:" << endl;
  boost_type_deducation(y);
  cout << endl;

  cout << "z:" << endl;
  boost_type_deducation(z);
  cout << endl;

  cout << "al:" << endl;
  boost_type_deducation(al);
  cout << endl;

  cout << "be:" << endl;
  boost_type_deducation(be);
  cout << endl;

  return 0;
}
