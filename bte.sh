#!/usr/bin/env bash

. `dirname $0`/config.sh

count=0
for i in ${OUT}/*.txt
do 
  let count++
  # if [[ -f ${PREDICT}/$(basename ${i} .txt).btxte ]]; then echo -n "."; continue; fi
  # echo -n "$(basename ${i} .txt) "
  ./bte.py ${i} ${OUT}/$(basename ${i} .txt).dom  > ${PREDICT}/$(basename ${i} .txt).btxte 
  cat ${PREDICT}/$(basename ${i} .txt).btxte
done > ${PREDICT}/allvecs.btxte
echo; echo ${count}


count=0
for i in ${OUT}/*.cl
do 
  let count++
  # if [[ -f ${PREDICT}/$(basename ${i} .cl).btcle ]]; then echo -n "."; continue; fi
  # echo -n "$(basename ${i} .cl) "
  ./bte.py ${i} ${OUT}/$(basename ${i} .cl).dom  > ${PREDICT}/$(basename ${i} .cl).btcle 
  cat ${PREDICT}/$(basename ${i} .cl).btcle
done > ${PREDICT}/allvecs.btcle
echo; echo ${count}
