from tkinter import *
import math

def run_turtle_program(program_str, width, height):
	root = Tk()
	canvas = Canvas(root, width=width, height=height)
	canvas.pack()

	canvas.create_text(10, 10, text=program_str, anchor=NW, fill="gray", font="Times 10")

	turtle_pos = [width/2, height/2]
	turtle_angle = 0
	turtle_color = "green"
	for line in program_str.split('\n'):
		line = line.split('#')[0]
		if line.strip() == '':
			continue
		command, arg = line.strip().split(' ')
		if command == "color":
			turtle_color = arg
		elif command == "left":
			arg = float(arg)
			turtle_angle = turtle_angle + arg
			if turtle_angle > 359:
				turtle_angle = turtle_angle - 360
		elif command == "right":
			arg = float(arg)
			turtle_angle = turtle_angle - arg
			if turtle_angle < 0:
				turtle_angle = turtle_angle + 360
		elif command == "move":
			arg = float(arg)
			dx = arg * math.cos(turtle_angle * math.pi/180)
			dy = arg * math.sin(turtle_angle * math.pi/180)
			if turtle_color != "none":
				canvas.create_line(turtle_pos[0], turtle_pos[1], turtle_pos[0]+dx, turtle_pos[1]-dy, fill=turtle_color, width=5)
			turtle_pos[0] = turtle_pos[0] + dx
			turtle_pos[1] = turtle_pos[1] - dy
		else:
			raise Exception("command: " + command + " is invalid")

	root.mainloop()


run_turtle_program("""
# This is a simple tortoise program
color blue
move 50

left 90

color red
move 100

color none # turns off drawing
move 50

right 45

color green # drawing is on again
move 50

right 45

color orange
move 50

right 90

color purple
move 100
""", 300, 400)


		
		

