#include <fstream>
#include <string>
#include <iostream>
#include <unordered_map>

using namespace std;


int main()
{
  ifstream infile("some_file.txt");
  string line;
  unordered_map<string,unsigned>
    counts({{"aa", 0}, {"ae", 0}, {"ai", 0}, {"ao", 0}, {"au", 0},
            {"ea", 0}, {"ee", 0}, {"ei", 0}, {"eo", 0}, {"eu", 0},
            {"ia", 0}, {"ie", 0}, {"ii", 0}, {"io", 0}, {"iu", 0},
            {"oa", 0}, {"oe", 0}, {"oi", 0}, {"oo", 0}, {"ou", 0},
            {"ua", 0}, {"ue", 0}, {"ui", 0}, {"uo", 0}, {"uu", 0}});
  
  while(getline(infile, line))
  {
    unsigned end_pos = line.size() - 1;
    for(unsigned i = 0; i < end_pos; ++i)
    {
      string temp_str = line.substr(i, 2);
      auto count_ptr = counts.find(temp_str); // look in the map for the key
      if (count_ptr != counts.end()) ++(count_ptr->second); // if found, increment
    }
  }

  for (const auto& map_pair : counts) 
    cout << map_pair.first << ": " << map_pair.second << '\n';

  return 0;
}
