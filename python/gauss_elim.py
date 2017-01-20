def gauss_elim(A, b):
    nrows = len(A)
    ncols = len(A[0])
    assert(nrows == ncols)
    assert(nrows == len(b))

    # j is the index of the pivot
    for j in range(nrows):
        # i is the index of the row we're operating on
        for i in range(j+1, nrows):
            # first calculate the multiplier, c, for the row
            c = A[i][j] / A[j][j]
            # row elimination
            for k in range(j, nrows):
                A[i][k] -= c * A[j][k]
            b[i] -= c * b[j]

A1 = [ [1.0, 2.0, 3.0], [-1.0, 2.0, -1.5], [3.0, -2.0, 1.0] ]
b1 = [ 1.5, -4.5, 0.5]

gauss_elim(A1, b1)

print('A1 = ')
for row in A1:
    print(row)
print('b1 = ', b1)

A2 = [ [1.0, 2.0, 3.0, 4.0, 5.0], 
       [-1.0, 2.0, -1.5, 0.5, 1.0], 
       [1.0, 2.0, -1.5, 0.5, 1.0], 
       [-1.0, 4.0, -2.5, 0.5, 1.0], 
       [3.0, -2.0, 1.0, 1.0, 2.5] ]
b2 = [ 1.5, -4.5, 0.5, 2.1, -3.4 ]

gauss_elim(A2, b2)

print('A2 = ')
for row in A2:
    print(row)
print('b2 = ', b2)
