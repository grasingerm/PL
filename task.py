"""
Devise a function that accepts an arbitrarily-nested array, and returns a flattened version of it. Do not
solve the task using a built-in function that can accomplish the whole task on its own.

Example:
[1,2,[3],[4,[5,6]],[[7]], 8] -> [1,2,3,4,5,6,7,8]
"""

def _flat_array(A, B):
    for a in A:
       if type(a) == list:
           _flat_array(a, B)
       else:
           B.append(a)

def flat_array(A):
    result = []
    _flat_array(A, result)
    return result

ex = [1,2,[3],[4,[5,6]],[[7]], 8]
print(flat_array(ex))

ex2 = [1, 2, [3], [4, [5, 6], 5, 6], [[7], [8, [9]]], 10]
ex3 = [1, 2, [3], [4, [5, 6], 5, 6], [[7], [8, [9]]], 10, [[[11], 12]]]

print(ex2, " => ", flat_array(ex2))
print(ex3, " => ", flat_array(ex3))
