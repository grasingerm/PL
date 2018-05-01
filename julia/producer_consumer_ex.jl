function producer()
  produce("start");
  for n=1:2
    produce(2*n);
  end
  produce("stop");
end

p = Task(producer)
for i=1:10
  println(consume(p));
end

println("Creating and consuming a new producer");
# alternative syntax
for x in Task(producer)
  println(x);
end
