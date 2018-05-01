# 15-112, Summer 1, Homework 3.1
######################################
# Full name: Lillian Sheng
# Andrew ID: tsheng 
# Section: B
######################################

######### IMPORTANT NOTE #############
# You may not use recursion, sets, dictionaries or any other constructs 
# that we have not yet covered in class.

import math

# This function takes an arbitrary list and returns True if it is a 
# magic square and False otherwise.
def isMagicSquare(a):

# This takes the sum of the first diagonal.  
    l=len(a)
    n=len(a[0])
    if l!=n:
        return False
    magic=0
    for i in range(0,len(a[0])):
        magic+=a[i][i]


# This takes the sum of the other diagonal.    
    total=0
    for j in range(0,len(a[0])):
        total+=a[n-1-j][j]
    if magic!=total:
        return False


# This takes the sum of the rows.
    for i in range(0,n):
        total=0
        for j in range(0,n):
            total+=a[i][j]
        if magic!=total:
            return False


# This takes the sum of the columns.
    for j in range(0,n):
        total=0
        for i in range(0,n):
            total+=a[i][j]
        if magic!=total:
            return False
    return True


# This function returns True if the integers represent a legal Kings Tour and 
# False otherwise.
def isKingsTour(board):
    seen=[]
    n=len(board[0])
    for i in range(0,n):
        for j in range(0,n):
            if board[i][j]<=0 or board[i][j]>n**2:
                return False
            if board[i][j]==1:
                if board[i][j] in seen:
                    return False
                seen.append(board[i][j])
                posx=j
                posy=i
    for q in range(2,n**2+1):
        for i in range(0,n):
            for j in range(0,n):
                if board[i][j]==q:
                    if board[i][j] in seen:
                        return False
                    seen.append(board[i][j])
                    if abs(posx-j)>1:
                        return False
                    if abs(posy-i)>1:
                        return False
                    posx=j
                    posy=i
    return True

# This function returns True if the values in any given row, column, or block
# in the Sudoku board are legal, and False otherwise.
def areLegalValues(values):
    seen=[]
    n=len(values)
    for i in range(0,len(values)):
        if values[i]<0 or values[i]>n:
            return False
        if values[i]!=0:
            if values[i] in seen:
                return False
            else:
                seen.append(values[i])
    return True


# This function returns True if the given row in the given board is legal 
# and False otherwise.
def isLegalRow(board, row):
    newList=[]
    for i in range(0,len(board[0])):
        newList.append(board[row][i])   
    return areLegalValues(newList)


# This function returns True if the given column in the given board is legal 
# and False otherwise.
def isLegalCol(board, col):
    newList=[]
    for i in range(0,len(board[0])):
        newList.append(board[i][col])   
    return areLegalValues(newList)


# This function returns True if the numbers in the block is legal and False
# otherwise.
def isLegalBlock(board, block):
    newList=[]
    n=len(board[0])
    l=int(n**0.5)
    x=int((block//l)*l)
    y=int(l*block%l)
    for i in range(0+x,x+l):
            for j in range(0+y,y+l):
                newList.append(board[i][j])
    return areLegalValues(newList)

 
# This function returns True if the boar is legal and False otherwise.
def isLegalSudoku(board):
    for i in range(0,len(board[0])):
        if not isLegalRow(board,i):
            return False
        if not isLegalCol(board,i):
            return False
        if not isLegalBlock(board,i):
            return False
    return True

# ######################################################################
# # ignore_rest: The autograder will ignore all code below here
# ######################################################################

# # Make sure every function is tested thoroughly before you submit to Autolab.

def testisMagicSquare():
    print("Testing isMagicSquare...", end="")
    assert(isMagicSquare([[2,7,6],[9,5,1],[4,3,8]])==True)
    assert(isMagicSquare([[2,7,5],[9,5,1],[4,3,8]])==False)
    assert(isMagicSquare([[7,12,1,14],[2,13,8,11],[16,3,10,5],[9,6,15,4]])==True)
    assert(isMagicSquare([[8, 1, 6], [3, 5, 7], [4, 9, 2], [1, 1, 1]])==False)
    print("Passed!")

def testisKingsTour():
    print("Testing isKingsTour...", end="")
    assert(isKingsTour([[  1, 14, 15, 16],
      [ 13,  2,  7,  6],
      [ 12,  8,  3,  5],
      [ 11, 10,  9,  4]
    ])==True)
    assert(isKingsTour([[3,2,1],[6,4,0],[5,7,8]])==False)
    assert(isKingsTour([[1,2,3],[7,4,8],[6,5,9]])==False)
    assert(isKingsTour([[3,2,1],[6,4,9],[5,7,8]])==True)
    assert(isKingsTour([[3,2,1],[6,4,1],[5,7,8]])==False)
    print("Passed!")

def testisLegalSudoku():
    print("Testing isLegalSudoku...", end="")
    assert(isLegalSudoku([
  [ 5, 3, 0, 0, 7, 0, 0, 0, 0 ],
  [ 6, 0, 0, 1, 9, 5, 0, 0, 0 ],
  [ 0, 9, 8, 0, 0, 0, 0, 6, 0 ],
  [ 8, 0, 0, 0, 6, 0, 0, 0, 3 ],
  [ 4, 0, 0, 8, 0, 3, 0, 0, 1 ],
  [ 7, 0, 0, 0, 2, 0, 0, 0, 6 ],
  [ 0, 6, 0, 0, 0, 0, 2, 8, 0 ],
  [ 0, 0, 0, 4, 1, 9, 0, 0, 5 ],
  [ 0, 0, 0, 0, 8, 0, 0, 7, 9 ]
]
))
    print("Passed!")

def testAll():
    testisMagicSquare()
    testisKingsTour()
    testisLegalSudoku()

testAll()
