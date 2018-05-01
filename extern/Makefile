all: hello

x.o: x.c
	$(CC) $(CFLAGS) -c x.c

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

hello: main.o x.o x.h
	$(CC) $(CFLAGS) main.o x.o -o hello

clean:
	rm -f *.o hello
