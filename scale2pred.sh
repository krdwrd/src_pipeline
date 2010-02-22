#!/bin/bash

. `dirname $0`/config.pipe

count=0

for a in ${SVMIN}/*.vecs
do
  let count++
  if [[ -f ${a}.scaled ]]; then echo -n "."; continue; fi
  echo -n "$(basename ${a} .vecs) "

  svm-scale -r ./svmin/full.canola.20090924/viz-dom.allvecs.scale_range $a > $a.scaled
done

echo
echo ${count}
