menu_msg = """Main menu:
================================
    1: option 1
    2: another option
    3: a third, important option

or 'exit', to quit. """

ans = input(menu_msg)
while ans != "exit":
    ans_number = int(ans)
    
    if ans_number == 1:
        print("you selected 1! Now the program will do option 1 things")
    elif ans_number == 2:
        print("you selected 2! Now the program will do option 2 things")
    elif ans_number == 3:
        print("you selected 3! Now the program will do option 3 things")

    ans = input(menu_msg)
