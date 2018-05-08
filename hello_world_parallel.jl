@everywhere id = myid();

N = nprocs();

pmap((x) -> println("Hello world! From, ", id), 1:N);
