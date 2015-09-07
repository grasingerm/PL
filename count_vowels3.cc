#include <fstream>
#include <string>
#include <iostream>

using namespace std;

int main()
{
  ifstream infile("some_file.txt");
  string line;
  unsigned counts[5][5] = {0};
  
  while(getline(infile, line))
  {
    unsigned end_pos = line.size();
    for(unsigned i = 0; i < end_pos; ++i)
    {
      char first_c = line[i];
      if (first_c == 'a')
      {
        char second_c = line[i+1];
        if (second_c == 'a') counts[0][0]++;
        elseif (second_c == 'e') counts[0][1]++;
        elseif (second_c == 'e') counts[0][1]++;
        elseif (second_c == 'e') counts[0][1]++;
        elseif (second_c == 'e') counts[0][1]++;
      }
      elseif (first_c == 'e')
      {
        char second_c = line[i+1];
        if (second_c == 'a') counts[1][0]++;
        elseif (second_c == 'e') counts[1][1]++;
        elseif (second_c == 'i') counts[1][2]++;
        elseif (second_c == 'e') counts[0][1]++;
        elseif (second_c == 'e') counts[0][1]++;
      }
    }

    cout << '\n'; 
  }

  count_aa

  return 0;
}
