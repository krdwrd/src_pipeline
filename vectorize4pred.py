#!/usr/bin/python
from sys import stdin
for l in stdin.xreadlines():
    line = " ".join(["%d:%f" % (i + 1, float(f)) for i, f in enumerate(l.split())])
    print "0 "+line
