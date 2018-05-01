"""
Download the s.txt file from:

http://goo.gl/sQIV1J

"Domino": We are given an S string, representing domino tiles chain. 
Each tile has L-R format, where L and R are numbered from 1..6 range. 
Tiles are separated by the comma. Some examples of valid S chain are:

1. "6-3"
2. "4-3,5-1,2-2,1-3,4-4"
3. "1-1,3-5,5-2,2-3,2-4"

Devise a function that will read from the given file line by line, where each line represents an input S string, and will return the number of tiles in the longest matching group within each input S string. A matching group is a set of tiles that match and that are subsequent in S. Domino tiles match if the right side of a tile is the same as the left side of the following tile. 2-4,4-1 are matching tiles, but 5-2,1-6 are not.

Function domino() should read file s.txt and return [1, 1, 3].
"""

def match(a, b):
    if a[-1] == b[0]:
        return True

def domino():
    counts = []
    with open("t.txt", "r") as f:
        for line in f:
            count = 1
            max_count = 1
            doms = [x.strip() for x in line.split(',')] 
            for i in range(len(doms)-1):
                if match(doms[i], doms[i+1]):
                    count += 1
                else:
                    if count > max_count: max_count = count
                    count = 1
            if count > max_count: max_count = count
            counts.append(max_count)
    return counts

print(domino())
