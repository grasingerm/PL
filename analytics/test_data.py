from data import *

print_log = True
test_table1 = [ [1, 1], [2, 2] ]
test_table2 = [ [0, 1], [2, 0] ]
test_table3 = [ [0, 1, 2, 3], [2, 0, 1], [-1, -1, -1, -1] ]
test_table4 = [ [10, 20, 30, 40, 50] ]
tolerance = 1e-4

def assert_almost_equal(x, y):
    global tolerance
    assert(abs( (x - y) / y ) < tolerance)

def log(msg):
    global print_log
    if print_log:
        print(msg)

def test_row_lens():
    global test_table1
    global test_table2
    global test_table3
    global test_table4

    print("testing table 1")
    assert(row_lens(test_table1) == [2, 2])
    print("testing table 2")
    assert(row_lens(test_table2) == [2, 2])
    print("testing table 3")
    assert(row_lens(test_table3) == [4, 3, 4])
    print("testing table 4")
    assert(row_lens(test_table4) == [5])

def test_row_sums():
    global test_table1
    global test_table2
    global test_table3
    global test_table4

    print("testing table 1")
    assert(row_sums(test_table1) == [2, 4])   
    print("testing table 2")   
    assert(row_sums(test_table2) == [1,2])
    print("testing table 3")
    assert(row_sums(test_table3) == [6,3,-4])   
    print("testing table 4")
    assert(row_sums(test_table4) == [150])

def run_test(test_func, test_name):
    try:
        test_func()
        print(test_name, " passed!")
    except:
        print(test_name, " FAILED.")

for test_func, test_name in zip([test_row_lens, test_row_sums], ["Row length test", "Row sums test"]):
    run_test(test_func, test_name)
