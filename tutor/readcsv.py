r = open("some.csv")

for line in r:
    vals = line.split(",")
    row_sum = 0
    for val in vals:
        row_sum += int(val)
    print(row_sum)
