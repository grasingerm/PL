macro __YOLO(); return "hello yolo"; end

function helloworld(msg::AbstractString=@__YOLO())
  println(msg);
end

helloworld();
