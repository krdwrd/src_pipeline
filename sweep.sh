#!/bin/bash

BASE=$(dirname $0)
URL=$1
TMPOUT=$(tempfile) || exit 1

FEATS="xy2-bte-dom-txtf"
SCALE="xy2-bte-dom-txtf.scale" 
MODEL="xy2-bte-dom-txtf.mod" 

app/krdwrd -pipe "$URL" -pic -out "$TMPOUT" -proxy "\"\"" 
$BASE/txtf.sh "$TMPOUT".txt "$TMPOUT".txtf
$BASE/vectorize2c.sh "$TMPOUT" "$FEATS" "$TMPOUT"  
$BASE/scale2c.sh "$TMPOUT.${FEATS}".vecs "$SCALE" "$TMPOUT".scaled
svm-predict "$TMPOUT".scaled "$MODEL" "$TMPOUT".silver
app/krdwrd -sweep "$URL" -sweepin "$TMPOUT".silver -out "$TMPOUT" -proxy "\"\""

echo
echo "output in: $TMPOUT"
