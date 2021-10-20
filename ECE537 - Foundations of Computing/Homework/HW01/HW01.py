# # ECE 537: Foundations of Computing
# 
# H = Number of times we hire a new office assistant

from itertools import permutations
from math import factorial, log

n = 8
count = 0
A = factorial(int(n))
EH = log(n)
print("There are", A, "permutations.")
print("The expected number of hires is:",EH)

perms = permutations(range(1, n+1))
sum = 0
for k in list(perms):
    count += 1  # Enumerate the permutations
    temp = max(k)   # Find maximum element in each permutation (best candidate to hire)
    H = [i+1 for i, j in enumerate(k) if j == temp]  # Use list comprehension to determine the index of the maximum element we just found
    # sum += H[0]
    print(count,": ",k,"\t\tNumber of hires:\t",H[0],"\t")
    