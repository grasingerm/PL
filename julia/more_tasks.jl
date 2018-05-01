t = @task begin 
  for x in [1, 2, 4]
    println(x);
  end
end

@show istaskdone(t);
@show current_task();

consume(t);
