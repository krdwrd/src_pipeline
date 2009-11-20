#!/bin/bash

. `dirname $0`/config.sh

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`

    if [[ -f ${SVMIN}/${i}.target ]]; then echo -n "."; continue; fi
    
    echo -n "${i} "
    ./target.py < $g > $SVMIN/$i.target
done
echo; echo ${count}

###

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    paste -d ' ' $OUT/$i.{viz,dom} | ./vectorize.py > $SVMIN/$i.viz-dom.vecs
    paste -d ' ' $SVMIN/$i.{target,viz-dom.vecs}
done > $SVMIN/viz-dom.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    paste -d ' ' $OUT/$i.{viz,clfeat} | ./vectorize.py > $SVMIN/$i.viz-cl.vecs
    paste -d ' ' $SVMIN/$i.{target,viz-cl.vecs}
done > $SVMIN/viz-cl.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    paste -d ' ' $OUT/$i.{viz,txtfeat} | ./vectorize.py > $SVMIN/$i.viz-txt.vecs
    paste -d ' ' $SVMIN/$i.{target,viz-txt.vecs}
done > $SVMIN/viz-txt.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    paste -d ' ' $OUT/$i.{dom,clfeat} | ./vectorize.py > $SVMIN/$i.dom-cl.vecs
    paste -d ' ' $SVMIN/$i.{target,dom-cl.vecs}
done > $SVMIN/dom-cl.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    paste -d ' ' $OUT/$i.{dom,txtfeat} | ./vectorize.py > $SVMIN/$i.dom-txt.vecs
    paste -d ' ' $SVMIN/$i.{target,dom-txt.vecs}
done > $SVMIN/dom-txt.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    cat $OUT/$i.dom | ./vectorize.py > $SVMIN/$i.dom.vecs
    paste -d ' ' $SVMIN/$i.{target,dom.vecs}
done > $SVMIN/dom.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    cat $OUT/$i.clfeat | ./vectorize.py > $SVMIN/$i.cl.vecs
    paste -d ' ' $SVMIN/$i.{target,cl.vecs}
done > $SVMIN/cl.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    cat $OUT/$i.clf | ./vectorize.py > $SVMIN/$i.clf.vecs
    paste -d ' ' $SVMIN/$i.{target,clf.vecs}
done > $SVMIN/clf.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    cat $OUT/$i.txtfeat | ./vectorize.py > $SVMIN/$i.txt.vecs
    paste -d ' ' $SVMIN/$i.{target,txt.vecs}
done > $SVMIN/txt.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    cat $OUT/$i.txtf | ./vectorize.py > $SVMIN/$i.txtf.vecs
    paste -d ' ' $SVMIN/$i.{target,txtf.vecs}
done > $SVMIN/txtf.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    cat $OUT/$i.viz | ./vectorize.py > $SVMIN/$i.viz.vecs
    paste -d ' ' $SVMIN/$i.{target,viz.vecs}
done > $SVMIN/viz.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    paste -d ' ' $OUT/$i.{dom,clfeat,viz} | ./vectorize.py > $SVMIN/$i.dom-cl-viz.vecs
    paste -d ' ' $SVMIN/$i.{target,dom-cl-viz.vecs}
done > $SVMIN/dom-cl-viz.allvecs
echo; echo ${count}

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`
    paste -d ' ' $OUT/$i.{dom,txtfeat,viz} | ./vectorize.py > $SVMIN/$i.dom-txt-viz.vecs
    paste -d ' ' $SVMIN/$i.{target,dom-txt-viz.vecs}
done > $SVMIN/dom-txt-viz.allvecs
echo; echo ${count}

#count=0
#for g in $OUT/*.gold
#do
#    let count++
#    i=`basename $g .gold`
#    paste -d ' ' $OUT/$i.{viz,dom,txtfeat} | ./vectorize.py > $SVMIN/$i.viz-dom-txt.vecs
#    paste -d ' ' $SVMIN/$i.{target,viz-dom-txt.vecs}
#done > $SVMIN/viz-dom-txt.allvecs
#echo; echo ${count}

