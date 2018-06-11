f = open("some.csv", "w")

#list_of_nums = list(map(str, range(1, 11)))
#comma_delim_nums = ",".join(list_of_nums)
#f.write(comma_delim_nums + "\n")

for row in range(0, 1000, 10):
    for x in range(1, 10):
        f.write(str(row + x) + ",")
    f.write(str(row + 10) + "\n")

f.close()
