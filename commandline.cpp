#include <boost/program_options/options_description.hpp>
#include <boost/program_options/parsers.hpp>
#include <boost/program_options/variables_map.hpp>
#include <boost/tokenizer.hpp>
#include <boost/token_functions.hpp>

using namespace boost;
using namespace boost::program_options;

#include <iostream>
#include <fstream>
#include <exception>

using namespace std;

//("long-name,short-name", "Description of argument")
//("long-name,short-name", <data-type>, "Description of argument")

int main(int argc, char **argv) {
  options_description desc("\nAn example command using Boost command line "
                           "arguments.\n\nAllowed arguments");

  desc.add_options()
    ("help,h", "Produce this help message.")
    ("memory-report,m", "Print a memory usage report to the log at termination.")
    ("restart,r", "Restart the application.")
    ("template,t", "Creates an input file template of the specified name "
                   "and then exits.")
    ("validate,v", "Validate an input file for correctness and then exits.")
    ("output-file,o", value<vector<string>>(), "Specifies output file.")
    ("input-file,i", value<vector<string>>(), "Specifies input file.");

  positional_options_description p;
  p.add("input-file", -1);

  variables_map vm;
  try {
    store(command_line_parser(argc, argv).options(desc).positional(p).run(), vm);
    notify(vm);
  } catch(std::exception &e) {
    cout << endl << e.what() << endl;
    cout << desc << endl;
  }

  if (vm.count("help")) {
    cout << "--help specified" << endl;
    cout << desc << endl;
  }

  if (vm.count("memory-report")) {
    cout << "--memory-report specified" << endl;
  }

  if (vm.count("restart")) {
    cout << "--restart specified" << endl;
  }

  if (vm.count("template")) {
    cout << "--template specified" << endl;
  }

  if (vm.count("output-file")) {
    vector<string> output_filename = vm["output-file"].as<vector<string>>();
    cout << "--output-file specified with value = " << output_filename[0] << endl;
  }

  if (vm.count("input-file")) {
    vector<string> input_filename = vm["input-file"].as<vector<string>>();
    cout << "--input-file specified with value = " << input_filename[0] << endl;
  }

  return EXIT_SUCCESS;
}
