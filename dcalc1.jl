module Difference

import FastAnonymous;

immutable ConstSequence
  i_start::Int;
  values::Vector{Float64};

  Sequence(i_start::Int, values::Vector{Float64}) = new(i_start, values);
end

function call(s::ConstSequence, n::Int)
  if n < s.i_start || n > s.i_start + length(s.values)
    error("Out of domain on which sequence is defined");
  end
  
  return s.values[s.i_start + n];
end 

function call(s::ConstSequence, nreal::Real)
  const n = convert(Int, nreal);
  if n < s.i_start || n > s.i_start + length(s.values)
    error("Out of domain on which sequence is defined");
  end
  
  return s.values[s.i_start + n];
end

typealias Sequence Union{Function, FastAnonymous.Fun, ConstSequence};

const __PASCALS_TRI_ = (Vector{Int}[
  [ -1,   1                                       ],
  [  1,  -2,   1                                  ],
  [ -1,   3,  -3,   1                             ],
  [  1,  -4,   6,  -4,   1                        ],
  [ -1,   5, -10,  10,  -5,   1                   ],
  [  1,  -6,  15, -20,  15,  -6,   1              ],
  [ -1,   7, -21,  35, -35,  21,  -7,   1         ],
  [  1,  -8,  28, -56,  70, -56,  28,  -8,   1    ],
  [ -1,   9, -36,  84, -126, 126, -84, 36,  -9,  1],
]);

#! Compute the forward difference of a sequence
#!
#! \param     seq     Sequence
#! \param     n       Index at which to take compute difference
#! \param     order   Order of difference
#! \return    Forward difference
function fdiff(seq::Sequence, n::Int; order::Int=1)
  @assert(order > 0 && order < length(__PASCALS_TRI_),
          "unable to compute $order order forward difference");

  sum = 0.0;
  for (offset, coeff) in enumerate(__PASCALS_TRI_[order])
    sum += coeff * seq(n - 1.0 + offset);
  end

  return sum;
end

#! Compute the forward difference of a sequence
#!
#! \param     seq     Sequence
#! \param     n_start Index at which to start computing differences
#! \param     n_end   Index at which to end computing differences
#! \param     order   Order of difference
#! \return    Forward differences
function fdiff(seq::Sequence, n_start::Int, n_end::Int; order::Int=1)
  return pmap(n -> fdiff(seq, n, order=order), UnitRange{Int}(n_start, n_end));
end

#! Compute the forward difference of a sequence
#!
#! \param     seq     Sequence
#! \param     n_range Range of index for which to compute differences
#! \param     order   Order of difference
#! \return    Forward differences
function fdiff(seq::Sequence, n_range::UnitRange{Int}; order::Int=1)
  return pmap(n -> fdiff(seq, n, order=order), n_range);
end

#! Compute the forward difference of a sequence
#!
#! \param     seq     Sequence
#! \param     n_range Range of index for which to compute differences
#! \param     order   Order of difference
#! \return    Forward differences
function fdiff(seq::Sequence, n_range::UnitRange{Float64}; order::Int=1)
  return pmap(n -> fdiff(seq, n, order=order), 
              convert(UnitRange{Int}, n_range));
end

end # end module

using FastAnonymous;
using Difference;

a     =   @anon (n) -> 1 / (n^2 + 3*n + 2);
b1    =   @anon (n) -> (n - 1) / factorial(n); 
b2    =   @anon (n) -> (n + 1) / (n + 2); 
b3    =   @anon (n) -> n / (n + 1); 
b4    =   @anon (n) -> 1 / (n + 1); 
b5    =   @anon (n) -> (n + 2) / (n - 3); 
b6    =   @anon (n) -> (n^2 + 1) / (n + 1); 

ns    =   0:10;
as    =   pmap(a, ns);
b1s   =   Difference.fdiff(b1, ns);
b2s   =   Difference.fdiff(b2, ns);
b3s   =   Difference.fdiff(b3, ns);
b4s   =   Difference.fdiff(b4, ns);
b5s   =   Difference.fdiff(b5, ns);
b6s   =   Difference.fdiff(b6, ns);

for (i, bs) in enumerate((b1s, b2s, b3s, b4s, b5s, b6s))
  println(i);
  println("===========================");
  for (an, bn) in zip(as, bs)
    @printf("%.4lf == %.4lf ", an, bn);
    println(abs(an - bn) < 1e-5);
  end
  println();
end

s(K) = K/(2*K+4);
for K in (10, 20, 50)
  @show s(K), sum(map(a, 1:K));
  @show abs(s(K) - sum(map(a, 1:K))) < 1e-7;
end

e(n) = 2.0^n;
@show map(e, 1:10);
@show Difference.fdiff(e, 1:10);
@show Difference.fdiff(e, 1:10, order=2);
@show Difference.fdiff(e, 1:10, order=3);
@show Difference.fdiff(e, 1:10, order=4);
@show Difference.fdiff(e, 1:10, order=6);
