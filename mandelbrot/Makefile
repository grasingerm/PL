CC=clang
CFLAGS=-Wall -Wextra -O3

mandel: mandel.c gnuplot_i.o
	$(CC) $(CFLAGS) mandel.c gnuplot_i.o -o mandel -lm

pthread_ex: pthread_ex.c
	$(CC) $(CFLAGS) pthread_ex.c -o pthread_ex -lpthread
