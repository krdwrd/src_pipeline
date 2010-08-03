#!/bin/bash

if [[ -z "$1" || -z "$2" || -z "$3" || -n "$4" ]]
then
    echo "Usage:$(basename $0) INFILE SCALEFILE OUTFILE"
    echo " Scale features from INFILE according to SCALEFILE to OUTFILE"
    exit 1
fi

INFILE=$1
SCALE=$2
OUTFILE=$3

svm-scale -r "$SCALE" "$INFILE" > "$OUTFILE"
