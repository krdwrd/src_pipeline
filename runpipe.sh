#!/bin/bash

CONFIG=$(dirname $0)/config.pipe
if [ ! -f ${CONFIG} ]; then
    echo $(basename $0): Adapt FILE:config.dist and save it as $(basename ${CONFIG}) 
    exit 1
else
    . ${CONFIG}
fi

count=0
total=`wc -l < $PLAN`
for i in `cat $PLAN`
do
  let count++
  if [[ -f $OUT/$i.gold ]]; then  echo -n "."; continue; fi
  echo ""
  echo " ------ $count of $total (page id: ${i}) ------"
  echo ""
  $APP/krdwrd-f \
    -pipe $BASEURL/$i \
    -out $OUT/$i \
    -pic 
  #  -proxy localhost:1234
  #  -pipe https://krdwrd.org/pages/bin/subm/$i/2 \
done

echo
echo ${count}
