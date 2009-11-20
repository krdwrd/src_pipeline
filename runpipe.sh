#!/bin/bash

. `dirname $0`/config.sh

count=0
total=`wc -l < $PLAN`
for i in `cat $PLAN`
do
  let count++
  if [[ -f $OUT/$i.gold ]]; then  echo -n "."; continue; fi
  echo ""
  echo " ------ $count of $total (page id: ${i}) ------"
  echo ""
  $XULRUNNER $APP/application.ini \
    -pipe $BASEURL/$i \
    -out $OUT/$i
  #$XULRUNNER $APP/application.ini \
  #  -pipe https://krdwrd.org/pages/bin/subm/$i/2 \
  #  -out $OUT/$i
done

echo
echo ${count}
