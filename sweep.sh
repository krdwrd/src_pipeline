#!/bin/bash

export LC_ALL=en_US.UTF-8

BASE=$(dirname $0)
URL=$1
TMPOUT=$(mktemp -u) || exit 1
if [ -z $2 ]; then OUT=${TMPOUT}; else OUT=$2; fi
PROXY="\"\""
PROXY="proxy.unitn.it:3128"

FEATS=${FEATS:-"xy2-bte-dom-txtf"}
SCALE=${SCALE:-"${BASE}/xy2-bte-dom-txtf.scale"}
MODEL=${MODEL:-"${BASE}/xy2-bte-dom-txtf.mod"} 

###
# first run: produce the feature files then,
# use victor for the final txt features then,
# paste features side-by-side, i.e. make one feature file, then,
# scale the data then,
# use model to predict classes.
# finally, second run: apply the predicted tags onto the page 
$BASE/app/krdwrd -pipe "$URL" -pic -out "$OUT" -proxy "$PROXY" \
&& $BASE/txtf.sh "$OUT".txt "$OUT".txtf \
&& $BASE/vectorize2c.sh "$OUT" "${FEATS}" "$OUT" \
&& $BASE/libsvm/svm-scale -r "${SCALE}" "${OUT}.${FEATS}".vecs > "$OUT".scaled \
&& $BASE/libsvm/svm-predict "$OUT".scaled "${MODEL}" "$OUT".silver \
&& $BASE/app/krdwrd -sweep "$URL" -sweepin "$OUT".silver -out "$OUT" -proxy "$PROXY" \
&& echo -e "\noutput in: $OUT.{png,...pipes...}" \
|| echo $0: failed.
