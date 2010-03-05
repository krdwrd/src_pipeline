#!/bin/bash

. `dirname $0`/config.pipe

for i in ${SVMIN}/*.learn ${SVMIN}/*.test
do 
  echo -n "$(basename ${i}) "

  checkdata.py ${i}
done
