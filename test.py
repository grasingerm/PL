def read_matrix(fname, nrows, ncols):
    a = [[0] * ncols] * nrows
    with open(fname) as f:
        for (row, line) in enumerate(f):
            for (col, val) in enumerate(line.split('\t')):
                a[row][col] = float(val)
    return a

def sum_matrix(fname):
    sum = 0
    with open(fname) as f:
        for line in f:
            for val in line.split('\t'):
                sum = sum + float(val)
    return sum


a = read_matrix('A.csv', 10, 10)
print(a)

print(sum_matrix('A.csv'))
