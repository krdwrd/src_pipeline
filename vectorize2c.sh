#!/bin/bash

# will need this to match all feature files
shopt -s extglob

if [[ -z "$1" || -z "$2" || -z "$3" || -n "$4" ]]
then
    echo "Usage:$(basename $0) INFILEBaseName FEATURES OUTFILEBaseName"
    echo " Paste features from INFILE.* into one OUTFILE.vecs"
    echo
    echo " Example: $(basename $0) ./pipeout/101 xy2-bte-dom-txtf ./svmin/101" 
    exit 1
fi

INFBN=$1
FEATS=${2} # "xy2 bte dom txtf" 
GLOBFEATS=${2//-/,} # "xy2-bte-dom-txtf"
OUTFBN=$3

eval paste -d \' \' "${INFBN}."\{${GLOBFEATS}\} | ./vectorize2c.py > "$OUTFBN."${FEATS}.vecs
