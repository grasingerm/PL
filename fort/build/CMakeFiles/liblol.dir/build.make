# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.7

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/clementine/Dev/PL/fort

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/clementine/Dev/PL/fort/build

# Include any dependencies generated for this target.
include CMakeFiles/liblol.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/liblol.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/liblol.dir/flags.make

CMakeFiles/liblol.dir/liblol.f.o: CMakeFiles/liblol.dir/flags.make
CMakeFiles/liblol.dir/liblol.f.o: ../liblol.f
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/clementine/Dev/PL/fort/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building Fortran object CMakeFiles/liblol.dir/liblol.f.o"
	/usr/bin/f95  $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -c /home/clementine/Dev/PL/fort/liblol.f -o CMakeFiles/liblol.dir/liblol.f.o

CMakeFiles/liblol.dir/liblol.f.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing Fortran source to CMakeFiles/liblol.dir/liblol.f.i"
	/usr/bin/f95  $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -E /home/clementine/Dev/PL/fort/liblol.f > CMakeFiles/liblol.dir/liblol.f.i

CMakeFiles/liblol.dir/liblol.f.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling Fortran source to assembly CMakeFiles/liblol.dir/liblol.f.s"
	/usr/bin/f95  $(Fortran_DEFINES) $(Fortran_INCLUDES) $(Fortran_FLAGS) -S /home/clementine/Dev/PL/fort/liblol.f -o CMakeFiles/liblol.dir/liblol.f.s

CMakeFiles/liblol.dir/liblol.f.o.requires:

.PHONY : CMakeFiles/liblol.dir/liblol.f.o.requires

CMakeFiles/liblol.dir/liblol.f.o.provides: CMakeFiles/liblol.dir/liblol.f.o.requires
	$(MAKE) -f CMakeFiles/liblol.dir/build.make CMakeFiles/liblol.dir/liblol.f.o.provides.build
.PHONY : CMakeFiles/liblol.dir/liblol.f.o.provides

CMakeFiles/liblol.dir/liblol.f.o.provides.build: CMakeFiles/liblol.dir/liblol.f.o


# Object files for target liblol
liblol_OBJECTS = \
"CMakeFiles/liblol.dir/liblol.f.o"

# External object files for target liblol
liblol_EXTERNAL_OBJECTS =

libliblol.so: CMakeFiles/liblol.dir/liblol.f.o
libliblol.so: CMakeFiles/liblol.dir/build.make
libliblol.so: CMakeFiles/liblol.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/clementine/Dev/PL/fort/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking Fortran shared library libliblol.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/liblol.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/liblol.dir/build: libliblol.so

.PHONY : CMakeFiles/liblol.dir/build

CMakeFiles/liblol.dir/requires: CMakeFiles/liblol.dir/liblol.f.o.requires

.PHONY : CMakeFiles/liblol.dir/requires

CMakeFiles/liblol.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/liblol.dir/cmake_clean.cmake
.PHONY : CMakeFiles/liblol.dir/clean

CMakeFiles/liblol.dir/depend:
	cd /home/clementine/Dev/PL/fort/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/clementine/Dev/PL/fort /home/clementine/Dev/PL/fort /home/clementine/Dev/PL/fort/build /home/clementine/Dev/PL/fort/build /home/clementine/Dev/PL/fort/build/CMakeFiles/liblol.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/liblol.dir/depend

