#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>

using namespace std;

void getw(string &t, ifstream &in) { in >> t; }

int read_string(vector<string> &words, ifstream &in)
{
    int i = 0;
    while(!in.eof()) getw(words[i++], in);
    return i-1;
}

int main(int argc, char* argv[])
{
    vector<string> w(1000);    
    
    if (argc == 2)
    {
        ifstream in(argv[1]);
        int how_many = read_string(w, in);
        w.resize(how_many);
        sort(w.begin(), w.end());
        for (auto str : w) cout << str << "\t";
        cout << endl;
    }
    else
    {
        cout << "Useage: read_file {file_name}" << endl;
        return 1;
    }
    
    return 0;
}
