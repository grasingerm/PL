a = [1, 10, 4]
for x in a:
    if x % 2 == 0:
        print(x, " is even")
    else:
        print(x, " is odd")

for i in range(3):
    if a[i] % 2 == 0:
        print("The ", i, "th of a is ",a[i]," and it is even")
    else:
        print("The ",i,"th of a is ",a[i]," and it is odd")
