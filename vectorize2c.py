#!/usr/bin/python
from sys import stdin
for l in stdin.xreadlines():
    print "0 " + " ".join(["%d:%f" % (i + 1, float(f)) for i, f in enumerate(l.split())])
