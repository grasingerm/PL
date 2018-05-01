A = [ [1, 1, 1], [1, 2, 1], [-1, 1, 1] ]
b = [7, 3, -1]

print(A[0][2])

def gauss(A, b):
    nrows = len(A)
    ncols = len(A[0])
    assert(nrows == ncols)
    assert(nrows == len(b))

    q = 0
    while q < nrows-1:
        r = q
        k = q + 1
        while k < nrows:
            c = A[k][q] / A[q][q]
            # row elimination
            while r < nrows:
                A[k][r] -= c * A[q][r]
                r += 1
            b[k] -= c * b[q]
            k += 1
        q += 1

gauss(A, b)
print('A = ')
for i in range(len(A)):
    for j in range(len(A[0])):
        print(A[i][j], end=' ')
    print()

print('\nb = ')
for i in range(len(b)):
    print(b[i])
