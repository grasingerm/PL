def mult_by_negtwo(x):
    x.insert(0, 0)
    return x
    
def add_nbin(x, y):
    nx = len(x)
    ny = len(y)
    
    if nx < ny:
        res = [0]*ny
        carry = 0
        for i in range(nx):
            val = x[i] + y[i] + carry
            if val == 2:
                carry = -1
                res[i] = 0
            elif val == 1:
                carry = 0
                res[i] = 1
            elif val == 0:
                carry = 0
                res[i] = 0
            elif val == -1:
                carry = 0
                res[i] = 1
            else:
                raise "Digits should only be zero or one"
        val_nx = carry + y[nx]
        if val_nx == 0:
            res[nx] = 0
        else:
            res[nx] = 1
        for i in range(nx+1, ny):
            res[i] = y[i]
                
    elif ny < nx:
        res = [0]*nx
        carry = 0
        for i in range(ny):
            val = x[i] + y[i] + carry
            if val == 2:
                carry = -1
                res[i] = 0
            elif val == 1:
                carry = 0
                res[i] = 1
            elif val == 0:
                carry = 0
                res[i] = 0
            elif val == -1:
                carry = 0
                res[i] = 1
            else:
                raise "Digits should only be zero or one"
        val_ny = carry + x[ny]
        if val_ny == 0:
            res[ny] = 0
        else:
            res[ny] = 1
        for i in range(ny+1, nx):
            res[i] = x[i]
    else:
        res = [0]*ny
        carry = 0
        for i in range(ny):
            val = x[i] + y[i] + carry
            if val == 2:
                carry = -1
                res[i] = 0
            elif val == 1:
                carry = 0
                res[i] = 1
            elif val == 0:
                carry = 0
                res[i] = 0
            elif val == -1:
                carry = 0
                res[i] = 1
            else:
                raise "Digits should only be zero or one"
        if carry == -1:
            res.append(1)
            
    return res
    
def solution(A):
    res = [0]*(len(A)+1)
    res[0] = A[0]
    
    carry = 0
    for i in range(1, len(A)):
        val = A[i] + A[i-1] + carry
        if val == 2:
            carry = -1
            res[i] = 0
        elif val == 1:
            carry = 0
            res[i] = 1
        elif val == 0:
            carry = 0
            res[i] = 0
        elif val == -1:
            carry = 0
            res[i] = 1
        else:
            raise "Digits should only be zero or one"
    
    val = carry + A[-1]
    if val == 1 or val == -1:
        res[len(A)] = 1
    elif val == 0:
        res[len(A)] = 0
    else:
        raise "Digits should only be zero or one"
    
    while res[-1] == 0:
        res.pop()
        
    return res
        
print solution([1, 0, 0, 1, 1])
print solution([1, 0, 0, 1, 1, 1])
