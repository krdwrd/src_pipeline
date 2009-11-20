#!/usr/bin/python

import sys

for line in sys.stdin.xreadlines():
    vals = [float(f) for f in line.split()]
    print (len(vals) - 4) / 16.0,
    print " ".join(["%f" % f for f in vals[:4]]),
    if vals[3]:
        print vals[2] * vals[3],
        print sum(vals[7::4]) / vals[3],
        print sum([a*b for a, b in zip(vals[6::4], vals[7::4])]) / \
              (max (vals[2] * vals[3],1))
    else:
        print -1, -1, -1

