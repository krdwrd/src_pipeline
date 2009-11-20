#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
This module implements Finn's BTE (Body Text Extraction) algorithm for
extracting the main body text of a web page and avoiding the surrounding
irrelevant information. The description of the algorithm can be found
in A. Finn, N. Kushmerick, and B. Smyth. Fact or Fiction: Content 
classification for digital libraries. In DELOS Workshop: Personalisation
and Recommender System in Digital Libraries, 2001.

This version is part of the KrdWrd System (http://krdwrd.org) and works
on top of features extracted from 'the pipelines'.

Adapted from Jan Pomikálek's version 
[http://nlp.fi.muni.cz/~xpomikal/scripts/bte.py]
"""

import re

global verbose


def krdwrd2bte(in_txt, in_dom):

    retval = ""
    paraspan = []
    num_tokens = []
    num_internodes = []

    line_txt_old = None
    for line_txt, line_dom in zip(in_txt,in_dom):

        line_dom_vals = line_dom.split(' ')
        num_token = int(line_dom_vals[13])
        num_internode = int(line_dom_vals[14])

        if line_txt == line_txt_old:
            paraspan[len(paraspan)-1] = paraspan[len(paraspan)-1] + 1
            num_tokens[len(paraspan)-1] = num_tokens[len(paraspan)-1] + num_token
            num_internodes[len(paraspan)-1] =num_internodes[len(paraspan)-1] + num_internode
        else:
            paraspan.append(1)
            num_tokens.append(num_token)
            num_internodes.append(num_internode)
        line_txt_old = line_txt

    # this would be the number of nodes from the ROOT node to the first text
    # node - no need, here.
    num_internodes[0] = 0

    if verbose: print num_tokens
    if verbose: print num_internodes

    min,max = bte(num_tokens,num_internodes) 

    for i in range(0,len(num_tokens)):
        for j in range(paraspan[i]):
            if i < min or i > max:
                retval += "-1" + "\n"
            else:
                retval += "1" + "\n"

    if verbose: print min,max 

    return retval

def bte(tokens, internodes):
    """
    BTE algorithm. Outputs a pair of indices which indicate the beginning and
    end of the main
    body.
    """

    # find breakpoints
    breakpoints = []

    for i in range(len(tokens)):
        breakpoints.append((i,tokens[i] - internodes[i]))

    # find breakpoints range which maximises the score
    max_score = 0
    max_start = 0
    max_end   = 0
    for i in range(len(breakpoints)):
        score = breakpoints[i][1]
        if score > max_score:
            max_score = score
            if i > 0: max_start = breakpoints[i-1][0]+1
            else:     max_start = 0
            max_end   = breakpoints[i][0]
        for j in range(i+1, len(breakpoints)):
            score+= breakpoints[j][1]
            if score > max_score:
                max_score = score
                if i > 0: max_start = breakpoints[i-1][0]+1
                else:     max_start = 0
                max_end   = breakpoints[j][0]

    return (max_start, max_end)


def usage():
    return """Usage: bte.py [OPTIONS] [FILE.{txt,dom}]...
"""


if __name__ == '__main__':
    import getopt
    import sys
    
    verbose = False

    try:
        opts, args = getopt.getopt(sys.argv[1:], "vh", ["help"])
    except getopt.GetoptError, err:
        print >>sys.stderr, err
        print >>sys.stderr, usage()
        sys.exit(1)
    
    for o, a in opts:
        if o in ("-h", "--help"):
            print usage()
            sys.exit()
        elif o == "-v":
            verbose = True

    infile_txt = args[0]
    infile_dom = args[1]

    in_txt = open(infile_txt, 'r')
    in_dom = open(infile_dom, 'r')
    sys.stdout.write(krdwrd2bte(in_txt.readlines(), in_dom.readlines()))
    in_txt.close()
    in_dom.close()
