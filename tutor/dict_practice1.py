# Let's review some things about dictionaries.
# First, run this script and see what it prints.
# Next, read through the comments and fix the following functions: haskey,
# hasvalue, countvalue, and keys_from_value
#
# To create a dictionary, we use curly braces {}
# Key-value pairs are separated by commas, and syntax for a key-value pair
# is key : value
# 
# Example
dict1 = { 4 : "four", 3.0 : 3, "name" : "Matt", "date" : "2018-06-11" }
print(dict1)
print("""\nNotice: a key doesn't need to be a string. 
In the above, the integer 4 is a key and the float 3.0 is also a key\n""")

# To get the keys as a list, we can use the keys() method of the dictionary class
print(dict1.keys())

# Recall: we can use the keyword 'in' to check if an element is in a list
# For example,

print("\n")

primes = [2, 3, 5, 7, 9, 11, 13, 17]

if 17 in primes:
    print("Seventeen is a prime number. Hm, how about that.")
else:
    print("Seventeen is not a prime number. How sad.")

print("\n")

# Now, combine these two ideas to fix the function haskey
# This function should return True if the key is in the dictionary and False
# if it is not. Change the line "return False" to "return key in d.keys()".
# Does this work? Why?
def haskey(d, key):
    return False

# Here are some tests to see if your function works!
if haskey({"apple" : "red", "banana" : "yellow", "grape" : "purple"}, "grape"):
    print("YES. This is correct. This dictionary does have the key grape")
else:
    print("Nope. This is incorrect. This dictionary DOES have the key grape")

if haskey({"apple" : "red", "banana" : "yellow", "grape" : "purple"}, "yellow"):
    print("Nope. This is incorrect. This dictionary does not have the key yellow")
else:
    print("YES. This is correct. This dictionary does not have the key yellow")

if haskey({}, "key"):
    print("Nope. This is incorrect. This dictionary is empty")
else:
    print("YES. This is correct. This dictionary is empty so it has no keys")

print("\n")

# Alright, now do the same thing, but for hasvalue
def hasvalue(d, value):
    return False

# Here are some tests to see if your function works!
if hasvalue({"apple" : "red", "banana" : "yellow", "grape" : "purple"}, "grape"):
    print("Nope. This is incorrect. This dictionary does not have the value grape")
else:
    print("YES. This is correct. This dictionary does not have the value grape")

if hasvalue({"apple" : "red", "banana" : "yellow", "grape" : "purple"}, "yellow"):
    print("YES. This is correct. This dictionary does have the value yellow")
else:
    print("Nope. This is incorrect. This dictionary does have the value yellow")

if hasvalue({}, "value"):
    print("Nope. This is incorrect. This dictionary is empty")
else:
    print("YES. This is correct. This dictionary is empty so it has no values")

print("\n")

# Here are more difficult tasks. Each key must be unique. However, two different
# keys can map to the same value. Write a function that counts the number of
# values a given value appears. If this is unclear, check the tests to see how it
# should behave.
def countvalue(d, value):
    return 0

if countvalue({"apple" : "red", "banana" : "yellow", "grape" : "purple"}, "grape") != 0:
    print("Nope. This is incorrect. The count should be 0. Grape is not a value")
else:
    print("YES. This is correct. grape does not appear as a value")

if countvalue({"apple" : "red", "banana" : "yellow", "grape" : "purple"}, "purple") != 1:
    print("Nope. This is incorrect. The count should be 1.")
else:
    print("YES. This is correct. purple appears once as a value")

if countvalue({"apple" : "red", "banana" : "yellow", "grape" : "purple", "cherry" : "red"}, "red") != 2:
    print("Nope. This is incorrect. The count should be 2.")
else:
    print("YES. This is correct. red appears twice as a value")

if countvalue({}, "value") != 0:
    print("Nope. This is incorrect. The count should be 0.")
else:
    print("YES. This is correct. The dictionary is empty and has no values.")

if countvalue({"test1" : "A", "test2" : "B", "hw1" : "A", "hw2" : "A", "term paper" : "A", "final exam" : "C"}, "A") != 4:
    print("Nope. This is incorrect. The count should be 4.")
else:
    print("YES. This is correct. The letter grade 'A' occurs 4 times")

print("\n")

# Now, instead of just counting, return a list of the keys that the values were 
# mapped from
# Hint: you can iterate over key, value pairs like so
for (k, v) in dict1.items():
    print("The key, ", k, " mapped to the value, ", v)

print("\n")

def keys_from_value(d, value):
    return []

if keys_from_value({"apple" : "red", "banana" : "yellow", "grape" : "purple"}, "grape") != []:
    print("Nope. This is incorrect. The list should be empty. Grape is not a value")
else:
    print("YES. This is correct. grape does not appear as a value")

if keys_from_value({"apple" : "red", "banana" : "yellow", "grape" : "purple"}, "purple") != ["grape"]:
    print("Nope. This is incorrect. The list should be ['grape'].")
else:
    print("YES. This is correct")

temp_lst = keys_from_value({"apple" : "red", "banana" : "yellow", "grape" : "purple", "cherry" : "red"}, "red")
if "apple" in temp_lst and "cherry" in temp_lst:
    print("YES. Well done. Both apple and cherry should be in the list of keys")
else:
    print("Nope. This is incorrect. should have apple and cherry in the list")

if keys_from_value({}, "value") != []:
    print("Nope. This is incorrect. The count should be 0.")
else:
    print("YES. This is correct. The dictionary is empty and has no values.")

temp_lst = keys_from_value({"test1" : "A", "test2" : "B", "hw1" : "A", "hw2" : "A", "term paper" : "A", "final exam" : "C"}, "A")
if "test1" in temp_lst and "hw1" in temp_lst and "hw2" in temp_lst and "term paper" in temp_lst:
    print("YES. WELL DONE!")
else:
    print("Nope. Try again.")
