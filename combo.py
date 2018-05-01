def c(*args):
     if type(args[-1]) != list:
         print(args)
     else:
         for e in args[-1]:
             c(e, *args[:-1])
             
c([1, 2], [3, 4], [5, 6])

def cdict(s, *args):
     if type(args[-1]) != dict:
         print(s[:-1], *args)
     else:
         for (k, v) in args[-1].items():
             c(k + "_" + s, v, *args[:-1])

cdict("", {"alpha" : 3, "beta": 4}, {"": "poop"}, {"apple": 2, "banana": 89})

