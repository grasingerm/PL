def solution(X, A):
    # write your code in Python 2.7
    n = len(A)
    front = [0]*(n+1)
    back = [0]*(n+1)
    
    for i in range(1, n+1):
        front[i] += front[i-1]
        if A[i-1] == X:
            front[i] += 1
           
    for i in range(n-1, -1, -1):
        back[i] += back[i+1]
        if A[i] != X:
            back[i] += 1
            
    for i in range(n+1):
        if front[i] == back[i]:
            return front, back, i
            
f, b, i = solution(5, [5, 5, 1, 7, 2, 3, 5])
print f
print b
print i
