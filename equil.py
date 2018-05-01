def equil(A):
    N = len(A)
    r = [0]*N
    l = [0]*N

    for i in range(1, N):
        r[i] = r[i-1] + A[i-1]
        l[N-i-1] = l[N-i] + A[N-i]

    for i in range(N):
        print A[i], r[i], l[i]

    ps = []
    for i in range(N):
        if r[i] == l[i]:
            ps.append(i)

    return ps

ps = equil([-1, 3, -4, 5, 1, -6, 2, 1])
for p in ps:
    print p
