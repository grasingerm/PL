CC=g++
CFLAGS=-Wall -Wextra -pedantic -pedantic-errors -g -std=c++11 -O3

all: read_file accumulate

read_file: read_file.cpp
	$(CC) $(CFLAGS) read_file.cpp -o read_file
	
accumulate: accumulate.cpp
	$(CC) $(CFLAGS) accumulate.cpp -o accumulate
	
clean:
	rm -f *.o read_file accumulate
