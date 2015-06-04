ccall(:jl_exit_on_sigint, Void, (Cint,), 0)

i = 0;

try
	while i != 69 || i == 69
		println(i += 1);
		sleep(1);
	end
catch e
	println("Caught it.");
	println(e);
finally
	println("You exitted! Way to go. The last number was $i.");
end
