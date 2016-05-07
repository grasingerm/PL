def c(*args):
     if type(args[-1]) != list:
         print(args)
     else:
         for e in args[-1]:
             c(e, *args[:-1])
             
c([1, 2], [3, 4], [5, 6])
