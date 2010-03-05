#!/bin/bash

. `dirname $0`/config.pipe

for i in ${SVMIN}/*.scaled
do 
  # if [[ -f ${OUT}/$(basename ${i} .xy).viz ]]; then echo -n "."; continue; fi
  echo -n "$(basename ${i} .allvecs.scaled) "

  ./cross.py ${i}
done

echo "targetweight"
./cross.py ${SVMIN}/allvecs.targetweight
