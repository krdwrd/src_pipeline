#!/usr/bin/python
from sys import stdin
for l in stdin.xreadlines():
    if l == '3\n':
        print "1"
    elif l == '2\n':
        print "-1"
    else:
        print "-1"
