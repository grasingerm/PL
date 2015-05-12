require("debug.jl");

macro NDEBUG()
  return true;
end

@checkdebug(1 < 3, "1 is not less than 3???");
@checkdebug(1 > 3, "1 is not greater than 3! :)");
@checkdebug(false, "false should warn us");
@checkdebug(true, "true should not warn us");
@checkdebug(1 == 1 && 2 == 2, "this is definitely true");
@mdebug("yolo sauce");
@mdebug("nolo sauce");

println("checks finished.");
