#!/usr/bin/env bash

. `dirname $0`/config.pipe

count=0

for i in ${OUT}/*.xy
do 
  let count++
  # if [[ -f ${OUT}/$(basename ${i} .xy).viz ]]; then echo -n "."; continue; fi
  echo -n "$(basename ${i} .xy) "
  ./viz.py < ${i} > ${OUT}/$(basename ${i} .xy).viz
done

echo
echo ${count}
