@* An example of {\tt CWEB}.
This example is blah blah blah.
I just hope it works.

@ This is the \TeX part.
It contains explanatory material about what is going on in the section.
The include section is where header files are included to provide prototypes for library functions.
If |pa| is declared as `|int *pa|`, the assignment |pa=&a[0]| makes |pa| point to the zeroth element of |a|.

@c
#include <stdio.h>

@ If necessary, this section is typically where file specific function prototypes and global variables are defined.

@c
static const char* msg = "Hello world! This is the shit";

void say_hello_world();

@ This is where the magic happens.
The |main| function is what gets executed when the program is run.
By convention, the |main| function returns an |int|.
The |int| is generally an exit code.

@c
int main() {
  say_hello_world();
  return 0;
}

@ If applicable, this is generally where file specific function implementations go.
In the case of the hello world example, the say hello world function needs an implementation.

@c
void say_hello_world() {
  puts(msg);
}
