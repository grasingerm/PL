CC=g++
CFLAGS=-Wall -Wextra -pedantic -pedantic-errors -g -std=c++11 -O3

all: read_file accumulate msizes msizes_cpp

read_file: read_file.cpp
	$(CC) $(CFLAGS) read_file.cpp -o read_file
	
accumulate: accumulate.cpp
	$(CC) $(CFLAGS) accumulate.cpp -o accumulate
	
msizes: msizes.c
	gcc -Wall -Wextra -pedantic -pedantic-errors -g -std=c99 -O3 msizes.c -o msizes
    
msizes_cpp: msizes.c
	$(CC) $(CFLAGS) msizes.c -o msizes_cpp
	
clean:
	rm -f *.o read_file accumulate msizes msizes_cpp
