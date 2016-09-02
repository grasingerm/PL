/*2:*/
#line 10 "./hello_world2.w"

#include <stdio.h> 

/*:2*//*3:*/
#line 15 "./hello_world2.w"

static const char*msg= "Hello world! This is the shit";

void say_hello_world();

/*:3*//*4:*/
#line 25 "./hello_world2.w"

int main(){
say_hello_world();
return 0;
}

/*:4*//*5:*/
#line 34 "./hello_world2.w"

void say_hello_world(){
puts(msg);
}/*:5*/
