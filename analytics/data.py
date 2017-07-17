"""
Read a table in from a text file
args:
    * filename - name of path to text file
    * delim - delimiter between columns of each row
return:
    list of lists where each list denotes a row and is a list of columns
"""
def read_table(filename, delim=','):
    pass

"""
Collects the maximum value of each row into a list
args:
    * t - Table of values
return:
    list of row maximums
"""
def row_maxs(t):
    pass

"""
Collects the minimum value of each row into a list
args:
    * t - Table of values
return:
    list of row minimums
"""
def row_mins(t):
    pass

"""
Collects the lengths value of each row into a list
args:
    * t - Table of values
return:
    list of row lengths
"""
def row_lens(t):
    lens = []
    for row in t:
        count = 0
        for col in row:
            count += 1
        lens.append(count)
    return lens

"""
Collects the sums value of each row into a list
args:
    * t - Table of values
return:
    list of row sums
"""
def row_sums(t):
    sums = []
    for row in t:
        count = 0
        for col in row:
            count = count + col
        sums.append(count)
    return sums
          

"""
Collects the average value of each row into a list
args:
    * t - Table of values
return:
    list of row averages
"""
def row_avgs(t):
    pass
