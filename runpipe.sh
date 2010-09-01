#!/bin/bash

CONFIG=$(dirname $0)/config.pipe
if [ ! -f ${CONFIG} ]; then
    echo $(basename $0): Adapt FILE:config.dist and save it as $(basename ${CONFIG}) 
    exit 1
else
    . ${CONFIG}
fi

[ -d $OUT ] || mkdir -p $OUT

count=0
total=$(wc -l < $PLAN)
for i in $(cat $PLAN)
do
  let count++
  if [[ -f $OUT/$(printf "%04d" $i).gold ]]; then  echo -n "."; continue; fi
  echo ""
  echo " ------ $count of $total (page id: ${i}) ------"
  echo ""
  echo "$OUT/$(printf "%04d" $i)"
  $APP/krdwrd-f \
    -pipe $BASEURL/$i \
    -out $OUT/$(printf "%04d" $i) \
    -pic \
    -proxy proxy.krdwrd.org:8080 
  #  -pipe file:///home/egon/krdwrd/pipeline/pipeout/canola/$(printf "%04d" $i).html \
  #  -pipe $BASEURL/$i \
  #  -pipe https://krdwrd.org/pages/bin/subm/$i/2 \
done

echo
echo ${count}
