import copy
import bisect

def fast2(a):
    b = copy.copy(a)
    b.sort()

    for i in range(len(b)-1):
        if b[i] == b[i+1]:
            return False

    return True

print(fast2([1, 2, 3]), " should be True")
print(fast2([1, 2, 3, 4]), " should be True")
print(fast2([1, 2, 3, -1, -14, 4, 7, 9, 11, 38]), " should be True")
print(fast2([1, 2, 3, -1, -14, 4, 7, 9, 11, 38, -14]), " should be False")
print(fast2([1, 2, 3, 2, 1, 3]), " should be False")

def binary_search(L, target):
    start = 0
    end = len(L) - 1
    while(start <= end):
        middle = (start + end)//2
        if(L[middle] == target):
            return True
        elif(L[middle] > target):
            end = middle - 1
        else:
            start = middle + 1
    return False

a = [1, 2, 3, -1, -14, 4, 7, 9, 11, 38];
a.sort()

print(binary_search([1, 2, 3], 3), " should be True")
print(binary_search([1, 2, 3, 4], 2), " should be True")
print(binary_search(a, -14), " should be True")
print(binary_search([1, 2, 3], -4), " should be False")
print(binary_search([1, 2, 3, 4], 17), " should be False")
print(binary_search(a, 39), " should be False")

def fast3(a, b):
    n = len(a)                  # O(1)
    assert(n == len(b))         # O(1)
    result = 0

    #sort
    a2 = copy.copy(a)           # O(N)
    a2.sort()                   # O(Nlog(N))

    # O(N log(N))
    for c in b:
        # do something with binary search
        if not binary_search(a2, c): # log(N)
            result += 1

    return result

def slow3(a, b):
    # assume a and b are the same length n
    n = len(a)
    assert(n == len(b))
    result = 0
    for c in b:
        if c not in a:
            result += 1
    return result

a = [1, 2, 3, 4]
b = [3, 4, 5, 6]
c = [1, 1, 2, 2]
d = [6, 7, 8, 9]

assert(fast3(a, b) == slow3(a, b))
assert(fast3(b, a) == slow3(b, a))
assert(fast3(c, d) == slow3(c, d))
assert(fast3(d, c) == slow3(d, c))
assert(fast3(a, c) == slow3(a, c))
assert(fast3(c, a) == slow3(c, a))
assert(fast3(b, d) == slow3(b, d))
assert(fast3(d, b) == slow3(d, b))
print("Fast3 tests passed.")

def slow4(a, b):
    # assume a and b are the same length n
    n = len(a)
    assert(n == len(b))
    result = abs(a[0] - b[0])
    for c in a:
        for d in b:
            delta = abs(c - d)
            if (delta > result):
                result = delta
    return result

def fast4(a, b):
    n = len(a)
    assert(n == len(b))

    c = copy.copy(a)
    d = copy.copy(b)
    c.sort()
    d.sort()

    delta1 = abs(c[0] - d[-1])
    delta2 = abs(c[-1] - d[0])
    return max(delta1, delta2)

assert(fast4(a, b) == slow4(a, b))
assert(fast4(b, a) == slow4(b, a))
assert(fast4(c, d) == slow4(c, d))
assert(fast4(d, c) == slow4(d, c))
assert(fast4(a, c) == slow4(a, c))
assert(fast4(c, a) == slow4(c, a))
assert(fast4(b, d) == slow4(b, d))
assert(fast4(d, b) == slow4(d, b))
print("Fast4 tests passed.")

def slow5(a, b):
    # Hint: this is a tricky one!  Even though it looks syntactically
    # almost identical to the previous problem, in fact the solution
    # is very different and more complicated.
    # You'll want to sort one of the lists,
    # and then use binary search over that sorted list (for each value in
    # the other list).  In fact, you should use bisect.bisect for this
    # (you can read about this function in the online Python documentation).
    # The bisect function returns the index i at which you would insert the
    # value to keep the list sorted (with a couple edge cases to consider, such
    # as if the value is less than or greater than all the values in the list, 
    # or if the value actually occurs in the list).
    # The rest is left to you...
    #
    # assume a and b are the same length n
    n = len(a)
    assert(n == len(b))
    result = abs(a[0] - b[0])
    for c in a:
        for d in b:
            delta = abs(c - d)
            if (delta < result):
                result = delta
    return result

def fast5(a, b):
    n = len(a)
    assert(n == len(b))
    a2 = copy.copy(a)
    result = abs(a[0] - b[0])

    for c in b:
        i = bisect.bisect(a2, c)
        if i == 0:
            delta = abs(a2[i] - c)
        elif i == n:
            delta = abs(a2[i-1] - c)
        else:
            delta1 = abs(a2[i] - c)
            delta2 = abs(a2[i-1] - c)
            delta = min(delta1, delta2)
        if (delta < result):
            result = delta
    return result

assert(fast5(a, b) == slow5(a, b))
assert(fast5(b, a) == slow5(b, a))
assert(fast5(c, d) == slow5(c, d))
assert(fast5(d, c) == slow5(d, c))
assert(fast5(a, c) == slow5(a, c))
assert(fast5(c, a) == slow5(c, a))
assert(fast5(b, d) == slow5(b, d))
assert(fast5(d, b) == slow5(d, b))
print("Fast5 tests passed.")

def invertDictionary(d):
    inv_d = {}
    for (k, v) in d.items():
        inv_key = v
        if not inv_key in inv_d.keys():
            inv_d[inv_key] = set([k])
        else:
            inv_d[inv_key].add(k)
    return inv_d

print(invertDictionary({1: 2, 2: 3, 3: 4, 5: 3}))

def friendsOfFriends(d):
    fof = {}
    for (person, friends) in d.items():
        fof_item = set([])
        for friend in friends:
            fof_item |= d[friend]
        fof_item -= friends
        fof_item -= set([person])
        fof[person] = fof_item

    return fof

d = {'barney': set(['fred']), 'dino': set(['wilma']), 'fred': set(['bam-bam', 'wilma', 'betty', 'barney']), 'betty': set(['dino', 'wilma']), 'bam-bam': set(['fred']), 'wilma': set(['dino', 'betty', 'fred'])}
print(friendsOfFriends(d))
