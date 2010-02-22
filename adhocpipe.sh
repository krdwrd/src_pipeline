#!/bin/bash

. `dirname $0`/config.pipe
. ~/krdwrd/app/config.app

count=0
for i in `cat - | sed -e 's/.html//'`
do
  let count++
  if [[ -f ./pipeout/tmp/$(basename $i).gold ]]; then  echo -n "."; continue; fi
  echo ""
  echo " ------ $count (page id: ${i}) ------"
  echo ""
  RUNCMD="$KW_CMD -pipe file://${i}.html -out ~/krdwrd/tmp/pipeline/pipeout/tmp/$(basename $i) -follow"
  $RUNCMD > $FIFO &
  waitforapp
done

echo
echo ${count}
