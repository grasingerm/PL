include("MarchingSquares.jl");
using MarchingSquares;

const iso_value =   2.0;
const data1     =   readdlm("data1.csv");
const bi        =   bin_img(data1, iso_value);
cvs             =   bit_cells(bi);
println(typeof(cvs));
disambig_saddle_pts!(cvs, data1, iso_value);
lines           =   lininterp_cells(cvs, data1, iso_value);
@show lines;

const iso_value2  =   5.0;
const data2       =   readdlm("data2.csv");
const bi2         =   bin_img(data2, iso_value2);
cvs2              =   bit_cells(bi2);
println(typeof(cvs2));
disambig_saddle_pts!(cvs2, data2, iso_value2);
lines2            =   lininterp_cells(cvs2, data2, iso_value2);
@show lines2;
