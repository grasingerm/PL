#include <iostream>
#include <boost/program_options.hpp>

namespace po = boost::program_options;
using namespace std;

int main(int ac, char* av[]) {
  po::options_description desc("Allowed options");
  desc.add_options()
    ("help", "produce help message")
    ("compression", po::value<int>(), "set compression level");

  po::variables_map vm;
  po::store(po::parse_command_line(ac, av, desc), vm);
  po::notify(vm);

  if (vm.count("help")) {
    cout << desc << "\n";
    return 1;
  }

  if (vm.count("compression")) {
    cout << "Compression level was set to " <<
            vm["compression"].as<int>() << ".\n";
  } else {
    cout << "Compression level was not set.\n";
  }

  return 0;
}
