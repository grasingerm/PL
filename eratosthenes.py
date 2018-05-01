import sys
import math

def sieve_of_eratosthenes(n):
    markers = [True]*(n-1)

    i = 0
    while i < n-1:
        # Find next prime number
        while not markers[i]:
            i = i + 1
            if i > n-2:
                break

        # Initialize current prime and multiplier
        p = i + 2
        m = p
       
        # Mark all multiples of the current prime as not prime
        while m * p <= n:
            markers[m * p - 2] = False
            m = m + 1

        i = i + 1
    return markers

def print_usage_and_exit():
    print("usage: python eratosthenes.py max_prime", file=sys.stderr);
    exit(1)

if len(sys.argv) < 2:
    print_usage_and_exit()

try:
    n = int(sys.argv[1])
except ValueError:
    print("ERROR: invalid maximum prime number to generate, '{}'"
            .format(sys.argv[1]), file=sys.stderr)
    print_usage_and_exit()

if n < 2:
    print("ERROR: invalid maximum prime number to generate, '{}'"
            .format(n), file=sys.stderr)
    print("Maximum prime number must be greater than one")
    print_usage_and_exit()

spacing = math.ceil(math.log(n, 10)) + 1
nums_per_line = math.floor(75 / (spacing + 1))

print()
print("Finding primes less than or equal to {} using sieve of eratoshtenes...\n"
        .format(n))
markers = sieve_of_eratosthenes(n)

nums_per_line_counter = 0
for (i, is_prime) in enumerate(markers):
    if is_prime:
        print(repr(i + 2).rjust(spacing), end=" ")
        nums_per_line_counter = nums_per_line_counter + 1
        if nums_per_line_counter % nums_per_line == 0:
            print("\n")

print("\n\nComplete.\n")
