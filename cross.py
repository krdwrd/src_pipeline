#!/usr/bin/python

import sys
import os.path as osp
from itertools import chain, tee

inp = file(sys.argv[1]).readlines()
chain = chain(*tee(inp, 11))
alen = len(inp)/10

for i in range(10):

    learn = file(sys.argv[1] + (".%d.learn" % (i,)), 'w')
    learn.writelines(chain.next() for a in range(alen*7))
    learn.close()

    learn = file(sys.argv[1] + (".%d.test" % (i,)), 'w')
    learn.writelines(chain.next() for a in range(alen*3))
    learn.close()

    for a in range(alen):
        chain.next()
