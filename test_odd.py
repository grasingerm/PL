from odd import *

assert(isodd(3) == True)
assert(isodd(2) == False)
assert(isodd(-4) == False)
assert(isodd(3.2) == False)
assert(isodd("string") == False)
assert(isodd(31) == True)
assert(isodd(22) == False)
assert(isodd(42) == False)
assert(isodd(82) == False)
assert(isodd(28) == False)

print("Tests complete")
