#!/usr/bin/env python

import fileinput, random

lines = list()
for line in fileinput.input():
    lines.append(line.strip())

random.shuffle(lines)

for line in lines:
    print line
