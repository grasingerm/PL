name = input("What is your name? ")
answer = (input("And, are you coming or going? ")).strip()

if answer == "coming":
	print("Hello " + name + "!")
elif answer == "going":
	print("Goodbye " + name + ".")
else:
	print("I have no idea what you mean by: " + answer)
  


