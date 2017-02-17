import matplotlib.pyplot as plt

def gauss_elim(A, b):
    nrows = len(A)
    ncols = len(A[0])
    assert(nrows == ncols)
    assert(nrows == len(b))

    # j is the index of the pivot
    for j in range(nrows-1):
        # i is the index of the row we're operating on
        for i in range(j+1, nrows):
            # first calculate the multiplier, c, for the row
            c = A[i][j] / A[j][j]
            # row elimination
            for k in range(j, nrows):
                A[i][k] -= c * A[j][k]
            b[i] -= c * b[j]

def back_substitute(A, b):
    n = len(b)
    x = [0.0] * n
    x[n-1] = b[n-1] / A[n-1][n-1]
    for k in range(n-2, -1, -1):
        sk = 0.0
        for j in range(k+1, n):
            sk += A[k][j] * x[j]
        x[k] = (b[k] - sk) / A[k][k]

    return x

A1 = [ [1.0, 2.0, 3.0], [-1.0, 2.0, -1.5], [3.0, -2.0, 1.0] ]
b1 = [ 1.5, -4.5, 0.5]
init_A1 = [ [1.0, 2.0, 3.0], [-1.0, 2.0, -1.5], [3.0, -2.0, 1.0] ]
init_b1 = [ 1.5, -4.5, 0.5]

gauss_elim(A1, b1)
x1 = back_substitute(A1, b1)

print('A1 = ')
for row in A1:
    print(row)
print('b1 = ', b1)
print('x1 = ', x1)

A2 = [ [1.0, 2.0, 3.0, 4.0, 5.0], 
       [-1.0, 2.0, -1.5, 0.5, 1.0], 
       [1.0, 2.0, -1.5, 0.5, 1.0], 
       [-1.0, 4.0, -2.5, 0.5, 1.0], 
       [3.0, -2.0, 1.0, 1.0, 2.5] ]
b2 = [ 1.5, -4.5, 0.5, 2.1, -3.4 ]
init_A2 = [ [1.0, 2.0, 3.0, 4.0, 5.0], 
             [-1.0, 2.0, -1.5, 0.5, 1.0], 
             [1.0, 2.0, -1.5, 0.5, 1.0], 
             [-1.0, 4.0, -2.5, 0.5, 1.0], 
             [3.0, -2.0, 1.0, 1.0, 2.5] ]
init_b2 = [ 1.5, -4.5, 0.5, 2.1, -3.4 ]

gauss_elim(A2, b2)
x2 = back_substitute(A2, b2)

print('A2 = ')
for row in A2:
    print(row)
print('b2 = ', b2)
print('x2 = ', x2)

A3 = [ [1.0, 1.0, 1.0], [1.0, 2.0, 1.0], [-1.0, 1.0, 1.0] ]
b3 = [ 7.0, 3.0, -1.0]
init_A3 = [ [1.0, 1.0, 1.0], [1.0, 2.0, 1.0], [-1.0, 1.0, 1.0] ]
init_b3 = [ 7.0, 3.0, -1.0]

gauss_elim(A3, b3)
x3 = back_substitute(A3, b3)

print('A3 = ')
for row in A3:
    print(row)
print('b3 = ', b3)
print('x3 = ', x3)

def matrix_mult(A, x):
    ''' A is a n x n matrix
        x is a vector of n elements
        return b = A*x
    '''
    n = len(A)
    assert(len(x) == n)
    b = [0.0] * n
    for i in range(n):
        sum_i = 0.0
        for j in range(n):
            sum_i += A[i][j] * x[j]
        b[i] = sum_i

    return b

check_b3 = matrix_mult(init_A3, x3)
print(b3)

check_b1 = matrix_mult(init_A1, x1)
check_b2 = matrix_mult(init_A2, x2)

print("checking b1s")
print(check_b1)
print(init_b1)
print("checking b2s")
print(check_b2)
print(init_b2)

for i in range(len(check_b1)):
    assert(abs(init_b1[i] - check_b1[i]) < 1e-9)

for i in range(len(check_b2)):
    assert(abs(init_b2[i] - check_b2[i]) < 1e-9)

for i in range(len(check_b3)):
    assert(abs(init_b3[i] - check_b3[i]) < 1e-9)

A = [ [-2, 1], [1, 1] ]
b = [3, 6]
gauss_elim(A, b)
z = back_substitute(A, b)
print(z)

x = [-1, 0, 1, 2, 3]
y1 = [1, 3, 5, 7, 9]
y2 = [7, 6, 5, 4, 3]
plt.plot(x, y1, x, y2)
plt.legend(["y1", "y2"])
plt.show()
