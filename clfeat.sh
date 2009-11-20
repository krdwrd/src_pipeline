#!/usr/bin/env bash

. `dirname $0`/config.sh

count=0
for i in ${OUT}/*.txt
do
    let count++

    if [[ -f ${OUT}/$(basename ${i} .txt).txtf ]]; then echo -n "."; continue; fi

    echo -n "$(basename ${i} .txt) "
    PERL5LIB=${PERL5LIB}:$(dirname ${0})/victor ./victor/krdwrd.pl --config victor/configs/krdwrd.conf --format krdwrd ${i} ${OUT}/$(basename ${i} .txt).txtf;
done

echo
echo ${count}

#count=0
#for i in ${OUT}/*.cl
#do
#    let count++
#
#    if [[ -f ${OUT}/$(basename ${i} .cl).clf ]]; then echo -n "."; continue; fi
#
#    echo -n "$(basename ${i} .cl) "
#    PERL5LIB=${PERL5LIB}:$(dirname ${0})/victor ./victor/krdwrd.pl --config victor/configs/krdwrd.conf --format krdwrd ${i} ${OUT}/$(basename ${i} .cl).clf;
#done
#
#echo 
#echo ${count}

## cat ./${SVMIN}/*.clfeat > ${CORPUS}.feat
## canola <- read.table('canola.feat', header=FALSE, sep=" ", col.names=c("sentence.count","token.alpha-abs","token.alpha-rel","token.num-abs","token.num-rel","token.mixed-abs","token.mixed-rel","token.other-abs","token.other-rel","avg-word-length","avg-word-run","char.alpha-rel","char.num-rel","char.punct-rel","char.white.rel","char.other-rel","twins","regexp.date","regexp.time","doc.word-count","doc.sentence-count"))
#
count=0
for i in ${OUT}/*.txtf
do
    let count++

    if [[ -f ${OUT}/$(basename ${i} .txtf).txtfeat ]]; then echo -n "."; continue; fi

    echo -n "$(basename ${i} .txtf) " 
    awk '
        function min(num1,num2) {
            if (num1 < num2) return num1
            else return num2
        }  
        { print min($1/5,1),min($2/8,1),$3/100,min($4/3,1),$5/100,min($6/2,1),$7/100,min($8/7,1),$9/100,$10/10,min($11/10,1),$12/100,min($13/4,1),min($14/3,1),min($15/19,1),min($16/4,1),min($17/2,1),min($18/5,1),min($19/2,1),min($20/2500,1),$21/512}
        ' ${i} > ${OUT}/$(basename ${i} .txtf).txtfeat
done

echo 
echo ${count}

#count=0
#for i in ${OUT}/*.clf
#do
#    let count++
#
#    if [[ -f ${OUT}/$(basename ${i} .clf).clfeat ]]; then echo -n "."; continue; fi
#
#    echo -n "$(basename ${i} .clf) "
#    awk '
#        function min(num1,num2) {
#            if (num1 < num2) return num1
#            else return num2
#        }  
#        { print min($1/5,1),min($2/8,1),$3/100,min($4/3,1),$5/100,min($6/2,1),$7/100,min($8/7,1),$9/100,$10/10,min($11/10,1),$12/100,min($13/4,1),min($14/3,1),min($15/19,1),min($16/4,1),min($17/2,1),min($18/5,1),min($19/2,1),min($20/2500,1),$21/512}
#        ' ${i} > ${OUT}/$(basename ${i} .clf).clfeat
#done
#
#echo
#echo ${count}
