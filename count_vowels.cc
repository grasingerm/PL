#include <fstream>
#include <string>
#include <iostream>

using namespace std;

enum vowel_counts {A, E, I, O, U};

int main()
{
  ifstream infile("some_file.txt");
  string line;
  unsigned counts[5][5] = {0};

  while(getline(infile, line))
  {
    unsigned end_pos = line.size() - 1;
    for(unsigned i = 0; i < end_pos; ++i)
    {
      cout << line.substr(i, 2) << '|';
    }
    cout << '\n'; 
  }

  return 0;
}
