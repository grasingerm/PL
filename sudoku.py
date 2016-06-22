# mode-demo.py

from tkinter import *
from hw3 import *

####################################
# init
####################################

def init(data, board):
    # There is only one init, not one-per-mode
    data["mode"] = "splashScreen"
    data["score"] = 0
    assert(isLegalSudoku(board))
    data["rows"] = len(board)
    data["cols"] = len(board[0])
    assert(data["rows"] == data["cols"])
    data["width"] = 500
    data["height"] = 500
    data["margin"] = 50
    data["board"] = board
    data["selection"] = (-1, -1) # (row, col) of selection, (-1,-1) for none
    data["wasLegal"] = True
    data["done"] = []
    data["undone"] = []

####################################
# mode dispatcher
####################################

def mousePressed(event, data):
    if (data["mode"] == "splashScreen"): splashScreenMousePressed(event, data)
    elif (data["mode"] == "playGame"):   playGameMousePressed(event, data)
    elif (data["mode"] == "help"):       helpMousePressed(event, data)

def keyPressed(event, data):
    if (data["mode"] == "splashScreen"): splashScreenKeyPressed(event, data)
    elif (data["mode"] == "playGame"):   playGameKeyPressed(event, data)
    elif (data["mode"] == "help"):       helpKeyPressed(event, data)

def timerFired(data):
    if (data["mode"] == "splashScreen"): splashScreenTimerFired(data)
    elif (data["mode"] == "playGame"):   playGameTimerFired(data)
    elif (data["mode"] == "help"):       helpTimerFired(data)

def redrawAll(canvas, data):
    if (data["mode"] == "splashScreen"): splashScreenRedrawAll(canvas, data)
    elif (data["mode"] == "playGame"):   playGameRedrawAll(canvas, data)
    elif (data["mode"] == "help"):       helpRedrawAll(canvas, data)

####################################
# splashScreen mode
####################################

def splashScreenMousePressed(event, data):
    pass

def splashScreenKeyPressed(event, data):
    data["mode"] = "playGame"

def splashScreenTimerFired(data):
    pass

def splashScreenRedrawAll(canvas, data):
    canvas.create_text(data["width"]/2, data["height"]/2-20,
                       text="This is a splash screen!", font="Arial 26 bold")
    canvas.create_text(data["width"]/2, data["height"]/2+20,
                       text="Press any key to play!", font="Arial 20")

####################################
# help mode
####################################

def helpMousePressed(event, data):
    pass

def helpKeyPressed(event, data):
    data["mode"] = "playGame"

def helpTimerFired(data):
    pass

def helpRedrawAll(canvas, data):
    canvas.create_text(data["width"]/2, data["height"]/2-40,
                       text="This is help mode!", font="Arial 26 bold")
    canvas.create_text(data["width"]/2, data["height"]/2-10,
                       text="How to play:", font="Arial 20")
    canvas.create_text(data["width"]/2, data["height"]/2+15,
                       text="Do nothing and score points!", font="Arial 20")
    canvas.create_text(data["width"]/2, data["height"]/2+40,
                       text="Press any key to keep playing!", font="Arial 20")

def pointInGrid(x, y, data):
    # return True if (x, y) is inside the grid defined by data
    return ((data["margin"] <= x <= data["width"]-data["margin"]) and
            (data["margin"] <= y <= data["height"]-data["margin"]))

def getCell(x, y, data):
    # aka "viewToModel"
    # return (row, col) in which (x, y) occurred or (-1, -1) if outside grid.
    if (not pointInGrid(x, y, data)):
        return (-1, -1)
    gridWidth  = data["width"] - 2*data["margin"]
    gridHeight = data["height"] - 2*data["margin"]
    cellWidth  = gridWidth / data["cols"]
    cellHeight = gridHeight / data["rows"]
    row = (y - data["margin"]) // cellHeight
    col = (x - data["margin"]) // cellWidth
    # triple-check that we are in bounds
    row = min(data["rows"]-1, max(0, row))
    col = min(data["cols"]-1, max(0, col))
    return (row, col)
    
def getCellBounds(row, col, data):
    # aka "modelToView"
    # returns (x0, y0, x1, y1) corners/bounding box of given cell in grid
    gridWidth  = data["width"] - 2*data["margin"]
    gridHeight = data["height"] - 2*data["margin"]
    columnWidth = gridWidth / data["cols"]
    rowHeight = gridHeight / data["rows"]
    x0 = data["margin"] + col * columnWidth
    x1 = data["margin"] + (col+1) * columnWidth
    y0 = data["margin"] + row * rowHeight
    y1 = data["margin"] + (row+1) * rowHeight
    return (x0, y0, x1, y1)

####################################
# playGame mode
####################################

def playGameMousePressed(event, data):
    (row, col) = getCell(event.x, event.y, data)
    # select this (row, col) unless it is selected
    if (data["selection"] == (row, col)):
        data["selection"] = (-1, -1)
    else:
        data["selection"] = (int(row), int(col))

def playGameKeyPressed(event, data):
    if (event.keysym == 'h'):
        data["mode"] = "help"
    elif (event.keysym in "123456789" and data["selection"] != (-1, -1)):
        row, col = data["selection"]
        val = int(event.keysym) # convert to integer 
        prev_val = data["board"][row][col]
        data["board"][row][col] = val
        data["done"].append((row, col, prev_val))
        if not isLegalSudoku(data["board"]):
            data["board"][row][col] = prev_val
            data["wasLegal"] = False
        else:
            data["wasLegal"] = True
    elif (event.keysym == 'u' and len(data["done"]) > 0):
        row, col, val = data["done"].pop()
        curr_val = data["board"][row][col]
        data["board"][row][col] = val
        data["undone"].append((row, col, curr_val))
        data["wasLegal"] = True
    elif (event.keysym == 'r' and len(data["undone"]) > 0):
        prev_move = data["undone"].pop()
        row, col, val = prev_move
        curr_val = data["board"][row][col]
        data["board"][row][col] = val
        data["done"].append((row, col, curr_val))
        data["wasLegal"] = True

def playGameTimerFired(data):
    data["score"] += 1

def playGameRedrawAll(canvas, data):
    # draw grid of cells
    for row in range(data["rows"]):
        for col in range(data["cols"]):
            (x0, y0, x1, y1) = getCellBounds(row, col, data)
            fill = "orange" if (data["selection"] == (row, col)) else "cyan"
            canvas.create_rectangle(x0, y0, x1, y1, fill=fill)
            if data["board"][row][col] != 0:
                canvas.create_text((x1+x0)/2, (y1+y0)/2, text=str(data["board"][row][col]), font="Arial 20")
    if not data["wasLegal"]:
        canvas.create_text(225, 475, text="That move was illegal")

####################################
# use the run function as-is
####################################

def run(width=300, height=300):
    def redrawAllWrapper(canvas, data):
        canvas.delete(ALL)
        redrawAll(canvas, data)
        canvas.update()    

    def mousePressedWrapper(event, canvas, data):
        mousePressed(event, data)
        redrawAllWrapper(canvas, data)

    def keyPressedWrapper(event, canvas, data):
        keyPressed(event, data)
        redrawAllWrapper(canvas, data)

    def timerFiredWrapper(canvas, data):
        timerFired(data)
        redrawAllWrapper(canvas, data)
        # pause, then call timerFired again
        canvas.after(data["timerDelay"], timerFiredWrapper, canvas, data)
    # Set up data and call init
    data = dict()
    data["width"] = width
    data["height"] = height
    data["timerDelay"] = 100 # milliseconds
    init(data,  [
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
)
    # create the root and the canvas
    root = Tk()
    canvas = Canvas(root, width=data["width"], height=data["height"])
    canvas.pack()
    # set up events
    root.bind("<Button-1>", lambda event:
                            mousePressedWrapper(event, canvas, data))
    root.bind("<Key>", lambda event:
                            keyPressedWrapper(event, canvas, data))
    timerFiredWrapper(canvas, data)
    # and launch the app
    root.mainloop()  # blocks until window is closed
    print("bye!")

run(300, 300)

