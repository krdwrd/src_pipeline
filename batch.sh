#!/bin/bash

. ./config.pipe

# for mix in dom viz cl txt viz-dom viz-cl viz-txt dom-cl dom-txt dom-cl-viz dom-txt-viz; do
for mix in xy2 bte dom xy2-bte xy2-dom bte-dom xy2-bte-dom; do
for c in 1 2 5 7 10 25 100 1000; do
# for c in 1 2 5 7 10 25 100 1000; do
for g in 0.005 0.05 0.5; do
# for g in 0.001 0.005 0.0075 0.01 0.05 0.25 0.5 1 2; do
for f in svmin/canola/$mix.allvecs.scaled.[0-9].learn
do
     TEST=$SVMIN/`basename $f .learn`.test
     TESTW=$SVMIN/allvecs.targetweight.$(basename $f .learn | sed -e "s/.\+\.//").test
     MOD=$MODELS/`basename $f`.$c-$g.mod
     PRED=$PREDICT/`basename $TEST`.$c-$g.pred
     RES=$PREDICT/`basename $TEST`.$c-$g.res
     RESW=$PREDICT/`basename $TEST`.$c-$g.resw


     if [[ -f $RES ]]
     then
         echo "SKIP $RES"; echo
         continue
     fi
     touch $RES
     echo $RES

     svm-train -h 0 -c $c -g $g -m 768 $f $MOD
     # svm-train -s 2 -h 0 -c $c -g $g -m 768 $f $MOD
     svm-predict $TEST $MOD $PRED
     awk '{print $1;}' < $TEST | paste - $PRED | awk -f resw.awk >> $RES
     awk '{print $1;}' < $TEST | paste - $PRED $TESTW | awk -f resw.awk >> $RESW
done
done
done
done
