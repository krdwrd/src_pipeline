#!/bin/bash

. `dirname $0`/config.pipe
AWCORPUS=canola.20090924

PLAINCORPUS=$(dirname $0)/.plaincorp
SVMCORPUS=$(dirname $0)/.svmcorp
BTXTECORPUS=$(dirname $0)/.btxtecorp
BTCLECORPUS=$(dirname $0)/.btclecorp
POTACORPUS=$(dirname $0)/.potacorp


pages=$(ls -1 ${OUT}/../${AWCORPUS}/*.png | wc -l)
echo pages: ${pages}

if [[ ! -f ${PLAINCORPUS} ]]
then
    for a in ${OUT}/../${AWCORPUS}/*.png
    do
        BNAME=$(basename ${a} .png)
        cat ${OUT}/../${AWCORPUS}/${BNAME}.txt | uniq
    done > ${PLAINCORPUS}
    sed "s/[\"\|_.,;\!\?\(\)':\/ ]\+/\n/g" ${PLAINCORPUS} | tr [A-Z] [a-z] | sort | uniq -c | sort -rn > ${PLAINCORPUS}.num
fi

echo
echo plain pipeout
words=$(cat ${PLAINCORPUS}.num | wc -w)
#lines=$(cat ${PLAINCORPUS} | grep -vE "" | wc -l)
echo words: ${words} 
#echo lines: ${lines}

###

if [[ ! -f ${SVMCORPUS} ]]
then
    for a in ${OUT}/../${AWCORPUS}/*.png
    do
        BNAME=$(basename ${a} .png)
        paste ${SVMIN}/../full.${AWCORPUS}/${BNAME}.target ${OUT}/../${AWCORPUS}/${BNAME}.txt | grep -E "^1" | cut -f 2 | uniq
    done > ${SVMCORPUS}
    sed "s/[\"\|_.,;\!\?\(\)':\/ ]\+/\n/g" ${SVMCORPUS} | tr [A-Z] [a-z] | sort | uniq -c | sort -rn > ${SVMCORPUS}.num
fi

echo
echo "svm target paragraphs (lines)"
words=$(cat ${SVMCORPUS}.num | wc -w)
#lines=$(cat ${SVMCORPUS} | wc -l)
echo words: ${words} 
#echo lines: ${lines}

###

if [[ ! -f ${BTXTECORPUS} ]]
then
    for a in ${OUT}/../${AWCORPUS}/*.png
    do
        BNAME=$(basename ${a} .png)
        paste ${PREDICT}/../full.${AWCORPUS}/${BNAME}.btxte ${OUT}/../${AWCORPUS}/${BNAME}.txt | grep -E "^1" | cut -f 2 | uniq
    done > ${BTXTECORPUS}
    sed "s/[\"\|_.,;\!\?\(\)':\/ ]\+/\n/g" ${BTXTECORPUS} | tr [A-Z] [a-z] | sort | uniq -c | sort -rn > ${BTXTECORPUS}.num
fi

echo
echo "btxte targets (paragraphs)"
words=$(cat ${BTXTECORPUS}.num | wc -w)
echo words: ${words} 

###

if [[ ! -f ${BTCLECORPUS} ]]
then
    for a in ${OUT}/../${AWCORPUS}/*.png
    do
        BNAME=$(basename ${a} .png)
        paste ${PREDICT}/../full.${AWCORPUS}/${BNAME}.btcle ${OUT}/../${AWCORPUS}/${BNAME}.cl | grep -E "^1" | cut -f 2 | uniq
    done > ${BTCLECORPUS}
    sed "s/[\"\|_.,;\!\?\(\)':\/ ]\+/\n/g" ${BTCLECORPUS} | tr [A-Z] [a-z] | sort | uniq -c | sort -rn > ${BTCLECORPUS}.num
fi

echo
echo "btcle targets (nodes)"
words=$(cat ${BTCLECORPUS}.num | wc -w)
echo words: ${words} 

###

if [[ ! -f ${POTACORPUS} ]]
then
    echo 'run something like:
    for i in /home/egon/krdwrd/tmp/pipeline/pipeout/canola.html/*.html; do
        echo "file://"$i; 
    done | ./retrieve_and_clean_pages_from_url_list.pl | grep -vE "^CURRENT" > ~/krdwrd/tmp/pipeline/.potacorp' 
    exit 1
else
    sed "s/[\"\|_.,;\!\?\(\)':\/ ]\+/\n/g" ${POTACORPUS} | tr [A-Z] [a-z] | sort | uniq -c | sort -rn > ${POTACORPUS}.num
fi

echo
echo "pota target lines"
words=$(cat ${POTACORPUS}.num | wc -w)
#lines=$(cat ${POTACORPUS} | wc -l)
echo words: ${words} 
#echo lines: ${lines}

# paste .plaincorp.num .svmcorp.num .btecorp.num .potacorp.num | less
