#!/bin/bash

. `dirname $0`/config.sh

count=0
total=`wc -l < $PLAN`
for i in `cat $PLAN`
do
  let count++
  if [[ -f $OUT/$i.html ]]; then  echo -n "."; continue; fi
  echo ""
  echo " ------ $count of $total (page id: ${i}) ------"
  echo ""
  $XULRUNNER $APP/application.ini \
    -grab -url $BASEURL/$i -out /tmp/${CORPUS}/$i
  #$XULRUNNER $APP/application.ini \
  #  -pipe https://krdwrd.org/pages/bin/subm/$i/2 \
  #  -out $OUT/$i
done

echo
echo ${count}
