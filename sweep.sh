#!/bin/bash

BASE=$(dirname $0)
URL=$1
TMPOUT=$(tempfile) || exit 1
if [ -z $2 ]; then OUT=${TMPOUT}; else OUT=$2; fi

FEATS=${FEATS:-"xy2-bte-dom-txtf"}
SCALE=${SCALE:-"xy2-bte-dom-txtf.scale"}
MODEL=${MODEL:-"xy2-bte-dom-txtf.mod"} 

app/krdwrd -pipe "$URL" -pic -out "$OUT" -proxy "\"\"" 
$BASE/txtf.sh "$OUT".txt "$OUT".txtf
$BASE/vectorize2c.sh "$OUT" "$FEATS" "$OUT"  
$BASE/scale2c.sh "$OUT.${FEATS}".vecs "$SCALE" "$OUT".scaled
svm-predict "$OUT".scaled "$MODEL" "$OUT".silver
app/krdwrd -sweep "$URL" -sweepin "$OUT".silver -out "$OUT" -proxy "\"\""

echo
echo "output in: $OUT"
