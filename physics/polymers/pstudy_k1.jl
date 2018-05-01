const num_steps = Int(2e8);
E0s = [1.0;];
betas = [10.0;];
deltas = [0.5];
k1s = [1.1; 1.5; 2.5; 5.0; 10.0; 100.0];
k2s = [1.0];
phi0s = [rand(0.0:1e-3:2*pi)];
dxs = [0.2;];
dthetas = [0.2;];

counter = 1;

datafile = "pstudy_$(Int(round(time()))%rand(200:400)).csv";
open(w -> write(w, "k1, k2, E0, beta, phi0, delta, dx, dtheta, n0_1, n0_2, n0_3, p0_1, p0_2, p0_3, u0, exp_x_1, exp_x_2, exp_x_3, exp_x_4, exp_x_5, exp_x2_1, exp_x2_2, exp_x2_3, exp_x2_4, exp_x2_5, Delta_x_1, Delta_x_2, Delta_x_3, Delta_x_4, Delta_x_5, exp_pmag, exp_E, exp_E2, Delta_E, exp_E_abs_error, exp_E_sq_error, Z_approx, lambdas_1, lambdas_2, lambdas_3, lambdas_4, lambdas_5, lambdas_6, plambdas, plambdas_an, Z_an, E_an\n"),
     datafile, "w");
for dx in dxs, dtheta in dthetas, k1 in k1s, k2 in k2s, E0 in E0s, beta in betas, 
    phi0 in phi0s, delta in deltas

  println("$dx $dtheta $k1 $k2 $E0 $beta $phi0 $delta, $counter");

  fname = joinpath("temp", replace(@sprintf("k1-%.2lf_k2-%.2lf_E0-%.2lf_beta-%.2lf_phi0-%.2lf_delta-%.2lf_time-%d",
                                            k1, k2, E0, beta, phi0, delta, Int(round(time()))%rand(200:400)), "\.", "") * ".txt");

  try

    if rand([true, false])
      run(pipeline(`julia amorphous_dielectric_3d.jl --k1 $k1 --k2 $k2 --E0 $E0 --beta $beta --phi $phi0 --delta $delta --num-steps $num_steps --dx $dx --dtheta $dtheta`, stdout=fname));
    else
      run(pipeline(`julia amorphous_dielectric_3d.jl --k1 $k1 --k2 $k2 --E0 $E0 --beta $beta --phi $phi0 --delta $delta --num-steps $num_steps -A --dx $dx --dtheta $dtheta`, stdout=fname));
    end


    # write results to file intermittently (IO probably won't be the bottle neck)
    open(w -> begin

         for line in readlines(fname)
           eval(parse(line));
         end
         write(w, "$k1, $k2, $E0, $beta, $phi0, $delta, $dx, $dtheta, $(n0[1]), $(n0[2]), $(n0[3]), $(p0[1]), $(p0[2]), $(p0[3]), $u0, $(exp_x[1]), $(exp_x[2]), $(exp_x[3]), $(exp_x[4]), $(exp_x[5]), $(exp_x2[1]), $(exp_x2[2]), $(exp_x2[3]), $(exp_x2[4]), $(exp_x2[5]), $(Delta_x[1]), $(Delta_x[2]), $(Delta_x[3]), $(Delta_x[4]), $(Delta_x[5]), $exp_pmag, $exp_E, $exp_E2, $Delta_E, $exp_E_abs_error, $exp_E_sq_error, $Z_approx, $(lambdas[1]), $(lambdas[2]), $(lambdas[3]), $(lambdas[4]), $(lambdas[5]), $(lambdas[6]), $plambdas, $plambdas_an, $Z_an, $E_an\n");

       end,
       datafile, "a");
    rm(fname);

    counter += 1;

  catch x

    warn("Error occurred.");
    bt = catch_backtrace();
    showerror(STDERR, x, bt);
    Base.show_backtrace(STDERR, backtrace())

  end
    
end
