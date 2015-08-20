#include <vector>
#include <iostream>
#include <iterator>
#include <algorithm>
#include <cstdlib>
#include <cassert>

using namespace std;

//! wrapper for copying with a const_iterator
template<class Container, class OutputIterator>
OutputIterator ccopy(const Container& c, OutputIterator result)
{
  return copy(c.begin(), c.end(), result);
}

int main()
{
  vector<int> v;
  v.reserve(100);
  assert(v.capacity() >= 100); // reduntant, standard assures this

  v.resize(10);
  for (auto& el : v) el = rand() % 100 - 50;
  
  assert(v.size() == 10);

  cout << "Printing with a const_iterator\n";
  vector<int>::const_iterator vend = v.cend();
  for (vector<int>::const_iterator i = v.cbegin(); i != vend; ++i)
    cout << *i << "\n";
  cout << "\n";

  cout << "Printing with std::copy\n";
  copy(v.cbegin(), v.cend(), ostream_iterator<int>(cout, "\n") );
  cout << "\n";

  cout << "Printing with ccopy\n";
  ccopy(v, ostream_iterator<int>(cout, "\n") );
  cout << "\n";

  return 0;
}
