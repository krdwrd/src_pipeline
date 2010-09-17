#!/bin/bash

. $(dirname $0)/config.pipe

trap "exit 1" INT

for i in ${SVMIN}/*.learn ${SVMIN}/*.test
do
    {
        echo -n "$(basename ${i}) "
        checkdata.py ${i}
    } | grep -v "No error." || echo -n "."
done
