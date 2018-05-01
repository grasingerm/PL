#include <fstream>
#include <string>
#include <iostream>

using namespace std;

//enum vowel_counts {A, E, I, O, U};

int main()
{
  ifstream infile("some_file.txt");
  string line;
  //unsigned counts[5][5] = {0};
  
  unsigned count_aa = 0, count_ae = 0, ....... ;

  while(getline(infile, line))
  {
    unsigned end_pos = line.size() - 1;
    for(unsigned i = 0; i < end_pos; ++i)
    {
      string temp_str = line.substr(i, 2);
      if (temp_str == "aa") count_aa++;
      else if
      else if
      else if
      else if
      else if
      else if
      else if
      else if
    }
    cout << '\n'; 
  }

  count_aa

  return 0;
}
