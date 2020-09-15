%MATLAB for ECE345 Problem Set 1
conv([1 1],[1 4])

roots([1 5 4])

G = tf(4, [1 5 4])

G2 = tf(4, [1 1 4])

step(G,G2)