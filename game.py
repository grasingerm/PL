from tkinter import *
import random
import math

class general(object):
    def __init__(self,x,y,width,height,otype):
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.type = otype

    def setpos(self,x,y):
        self.x=x
        self.y=y

    def display(self,canvas):
        if (self.type=="cloud"):
            canvas.create_oval(self.x, self.y, self.x+self.width, self.y+self.height, fill="blue")
        elif (self.type=="wall"):
            canvas.create_rectangle(self.x-self.width/2,self.y-self.height/2,self.x+self.width/2,self.y+self.height/2,fill="brown")
        elif (self.type=="pipe"):
            canvas.create_oval(self.x-20,self.y-20, self.x+20,self.y+20,fill="cyan")
        elif (self.type == "flag"):
            canvas.create_rectangle(self.x,self.y,self.x+self.width,self.y+self.height,fill="black")
        else:
            canvas.create_rectangle(self.x-20,self.y-20,self.x+20,self.y+20, fill="orange") # error checking

def createCloud(data):
    y = random.randint(70,150)
    x = random.randint(30,2000)
    width = random.randint(25,40)
    height = random.randint(15,20)
    for i in range(len(data.w)):
        if isIntersect(data.c[i].x,data.c[i].y,x,y,data.c[i].width/2 + width/2,data.c[i].height/2 + height/2):
            createCloud(data)
            return False
    data.c.append(general(x,y,width,height,"cloud"))

def createWall(data):
    y = random.randint(150,290)
    x = random.randint(50,500)
    width = random.randint(15,25)
    height = random.randint(15,30)
    for i in range(len(data.w)):
        if isIntersect(data.w[i].x,data.w[i].y,x,y,data.w[i].width/2 + width/2,data.w[i].height/2 + height/2):
            createWall(data)
            return False
    data.w.append(general(x,y,width,height,"wall"))

def init(data):
    data.scrollX = 0  # amount view is scrolled to the right
    data.scrollMargin = 50 # closest player may come to either canvas edge
    data.playerX = data.scrollMargin # player's left edge
    data.playerY = 20  # player's bottom edge (distance above the base line)
    data.playerWidth = 15
    data.playerHeight = 15
    data.mapWidth = 600
    data.walls = 5
    data.wallX = [100,200,220,320,470]
    data.wallY = [290,290,290,290,290]
    data.wallWidth = [20,20,20,10,10]
    data.wallHeight = [20,12,30,20,30]
    data.currentWallHit = -1 # start out not hitting a wall
    data.clouds = 10
    data.c = [] # clouds
    data.w = [] # walls
    data.cloudColor = "blue"
    data.cloudWidth = 50
    data.cloudHeight = 20
    data.cloudSpacing = 80 # wall left edges are at 90, 180, 270,...
    data.cloudOffsets = []
    data.wallPoints = [0]*data.walls
    data.lineHeight = 10
    for i in range(data.clouds):
        createCloud(data)
    for i in range(data.walls):
        createWall(data)
    data.flag = general(200,100,5,200,"flag")

    data.groundY = data.height
    data.gravityMag = 3
    data.pipeImg = PhotoImage(file="pipe.png")
    data.p = [general(100, 300, 50, 100, "pipe")]

def isIntersect(s1x,s1y,s2x,s2y,dx,dy):
    if abs(s1x-s2x)<dx and abs(s1y-s2y)<dy:
        return True
    return False

def getPlayerBounds(data):
    # returns absolute bounds, not taking scrollX into account
    (x0, y1) = (data.playerX, data.groundY - data.playerY)
    (x1, y0) = (x0 + data.playerWidth, y1 - data.playerHeight)
    return (x0, y0, x1, y1)

def getBounds(obj):
    # returns absolute bounds, not taking scrollX into account
    (x0, y1) = (obj.x-obj.width/2, obj.y+obj.height/2)
    (x1, y0) = (x0 + obj.width, y1 - obj.height)
    return (x0, y0, x1, y1)

def getCloudBounds(cloud, data):
    # returns absolute bounds, not taking scrollX into account
    offset_x, offset_y = data.cloudOffsets[cloud];
    (x0, y1) = ((1+cloud) * data.cloudSpacing + offset_x, 
                data.height/2 + offset_y)
    (x1, y0) = (x0 + data.cloudWidth + offset_x, 
                y1 - data.cloudHeight + offset_y)
    return (x0, y0, x1, y1)

def boundsIntersect(boundsA, boundsB):
    # return l2<=r1 and t2<=b1 and l1<=r2 and t1<=b2
    (ax0, ay0, ax1, ay1) = boundsA
    (bx0, by0, bx1, by1) = boundsB
    return ((ax1 >= bx0) and (bx1 >= ax0) and
            (ay1 >= by0) and (by1 >= ay0))

def movePlayer(dx, dy, data):
    data.playerX += dx
    data.playerY += dy
    if (data.playerX < data.scrollX + data.scrollMargin):
        data.scrollX = data.playerX - data.scrollMargin
    if (data.playerX > data.scrollX + data.width - data.scrollMargin):
        data.scrollX = data.playerX - data.width + data.scrollMargin

    pbounds = getPlayerBounds(data)
    hit = False
    for i in range(len(data.w)):
        if boundsIntersect(pbounds, getBounds(data.w[i])):
            hit = True
    if hit:
        data.playerX -= dx
        data.playerY -= dy

    # scroll to make player visible as needed
    # if (data.playerX < data.scrollX + data.scrollMargin):
    #     data.scrollX = data.playerX - data.scrollMargin
    # if (data.playerX > data.scrollX + data.width - data.scrollMargin):
    #     data.scrollX = data.playerX - data.width + data.scrollMargin
    # and check for a new wall hit
    # wall = getWallHit(data)
    # if (wall != data.currentWallHit):
    #     data.currentWallHit = wall
    #     if (wall >= 0):
    #         data.wallPoints[wall] += 1
    # if (wall != -1):
    #     data.playerX -= dx
    #     data.playerY -= dy
    if not data.playerY > (data.height - data.groundY + data.lineHeight):
        data.playerY = data.height - data.groundY + data.lineHeight
    # if data.playerX > data.mapWidth:
    #     data.playerX = 0

def gravity(data):
    if data.playerY > (data.height - data.groundY):
        movePlayer(0, -data.gravityMag, data)

def mousePressed(event, data):
    pass

def keyPressed(event, data):
    if (event.keysym == "Left"):    movePlayer(-5, 0, data)
    elif (event.keysym == "Right"): movePlayer(+5, 0, data)
    elif (event.keysym == "space"): movePlayer(0, +20, data)

def timerFired(data):
    gravity(data)

def redrawAll(canvas, data):
    # draw the base line
    lineY = data.groundY - data.lineHeight
    canvas.create_rectangle(0, lineY, data.width, lineY+data.lineHeight,fill="brown")

    # draw the walls
    # (Note: should optimize to only consider walls that can be visible now!)
    sx = data.scrollX

    for i in range(len(data.w)):
        data.w[i].x -= sx
        data.w[i].display(canvas)
        data.w[i].x += sx

    # draw clouds
    for i in range(len(data.c)):
        data.c[i].x -= sx
        data.c[i].display(canvas)
        data.c[i].x += sx

    # draw flag
    data.flag.x -= sx
    data.flag.display(canvas)
    data.flag.y += sx

    # draw the player
    (x0, y0, x1, y1) = getPlayerBounds(data)
    canvas.create_oval(x0 - sx, y0, x1 - sx, y1, fill="cyan")
   
    for p in data.p:
        canvas.create_image(p.x - sx, p.y, image=data.pipeImg)

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
        canvas.after(data.timerDelay, timerFiredWrapper, canvas, data)
    # Set up data and call init
    class Struct(object): pass
    data = Struct()
    data.width = width
    data.height = height
    data.timerDelay = 100 # milliseconds
    # create the root and the canvas
    root = Tk()
    canvas = Canvas(root, width=data.width, height=data.height)
    canvas.pack()
    init(data)
    # set up events
    root.bind("<Button-1>", lambda event:
                            mousePressedWrapper(event, canvas, data))
    root.bind("<Key>", lambda event:
                            keyPressedWrapper(event, canvas, data))
    timerFiredWrapper(canvas, data)
    # and launch the app
    root.mainloop()  # blocks until window is closed
    print("bye!")

run(500, 300)
