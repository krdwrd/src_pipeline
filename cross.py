#!/usr/bin/python

import sys,getopt

def usage():
    print """Usage: """+sys.argv[0]+""" [OPTION] FILE"""
    print """Take input FILE and split it for k-fold cross validation into output files."""
    print """ -h, --help: this help text"""
    print """ -k: make k folds"""
    print """ -t, --trials: number of trials"""
    print """ -s, --shuffle: shuffle data (default when t>1)"""
    print
    print """ Output will go to: FILE.{0,...,k}.(learn|test)[-t{00,...,trials}]"""

def main():
    ks = 10     # number of folds
    trials = 1  # number of trials (yields trials * k results )
    trext = ""  # file extension for different trials
    shuff = False   # should the data be shuffled?

    try:
        opts, args = getopt.getopt(sys.argv[1:], "ht:sk:", ["help", "trials=", "shuffle"])
    except getopt.GetoptError, err:
        # print help information and exit:
        print str(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)

    for o, a in opts:
        if o in ("-h", "--help"):
            usage()
            sys.exit()
        elif o in ("-t", "--trials"):
            trials = int(a)
            if trials > 1: 
                shuff = True
                trext = "-t00"
        elif o in ("-s", "--shuffle"):
            shuff = True
        elif o == "-k":
            ks = int(a)
        else:
            assert False, "unhandled option"

    ifname = args[0]
    inp = file(ifname).readlines()
    idx = [i for i in xrange(len(inp))]

    # print """k =""",ks,""", trials =""",trials

    for trial in xrange(trials):
        k=0
        for training, validation in k_fold_cross_validation(idx, ks, shuff):

            # print training,validation,k
            learn = file(ifname + (".%d.learn%s" % (k,trext,)), 'w')
            learn.writelines( inp[x] for x in training )
            learn.close()

            learn = file(ifname + (".%d.test%s" % (k,trext)), 'w')
            learn.writelines( inp[x] for x in validation )
            learn.close()
            
            k=k+1
        trext='-t%02d' % (trial+1)

# modified version from:
# http://code.activestate.com/recipes/521906-k-fold-cross-validation-partition/
def k_fold_cross_validation(X, K = 10, randomise = False):
    """
    Generates K (training, validation) pairs from the items in X.

    Each pair is a partition of X, where validation is an iterable
    of length len(X)/K. So each training iterable is of length (K-1)*len(X)/K.

    If randomise is true, a copy of X is shuffled before partitioning,
    otherwise its order is preserved in training and validation.
    """
    if randomise: from random import shuffle; X=list(X); shuffle(X)
    for k in xrange(K):
        training = [x for i, x in enumerate(X) if i % K != k]
        validation = [x for i, x in enumerate(X) if i % K == k]
        yield training, validation

if __name__ == "__main__":
    main()
