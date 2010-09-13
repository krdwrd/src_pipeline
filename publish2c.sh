#!/bin/bash

if [[ -z "$1" || -z "$2" || -n "$3" ]]
then
 cat <<-EOH

Usage:
`basename $0` SOURCEDIR FILELISTNAME

create list of filtered filenames' basename + URL of runpipe2c.sh pages in SOURCEDIR
EOH
 exit 1
fi

# number of words, lines, chars to filter for
WRDS=${WRDS:-500}
LNS=${LNS:-2}
CHRS=${CHRS:-100000}

SRC=$1
FILELIST=$2
cnt=0   # success counter
log=0   # txt files counter
nlog=0  # no log file (not all: gold,cl,txt,dom,bte,xy2)
lt=0    # too small
gt=0    # too large
pfof=0  # reported 404 errors
gfof=0  # grep-ed 40{1,3,4} errors

test -f $FILELIST && rm $FILELIST
test -f $FILELIST.no && rm $FILELIST.no

for i in $(find $(dirname ${SRC})/$(basename ${SRC})/ -name '*.log' -printf '%f\n' | sort -n)
do
    # be verbose about progress every now and then - including after init
    if ! (( $log % 5000 )); then echo -n "${log} "; fi
    # but make sure to increment counter
    let log++

    fid=${i%.log}
    B=${SRC}/${fid}

    # check for the output files of an app run - without these we need not proceed
    [ -e ${B}.gold ] && [ -e ${B}.cl ] && [ -e ${B}.txt ] && [ -e ${B}.dom ] && [ -e ${B}.bte ] && [ -e ${B}.xy2 ] || \
    { 
        let nlog++
        echo "${fid} not:A" >> $FILELIST.no
        continue
    }

    [ -z "$(grep '^HRS: 200$' ${B}.log)" ] &&
    {
        let pfof++
        echo "${fid} err:n200" >> $FILELIST.no
        continue
    }

    # put wc's output into an array:
    #  W[0] lines
    #  W[1] words
    #  W[2] characters (...sort-of bytes unless complex UTF-8 chars)
    W=( $(wc -l -w -m < $B.cl) )
    
    # if
    #  - file has > $WRDS words,
    #  - is longer than $LNS line(s), 
    #  - and has < $CHRS chars
    # then consider it.
    if [[ "${W[1]}" -gt $WRDS && "${W[0]}" -gt $LNS && "${W[2]}" -lt CHRS ]]
    then
        # file has < 4500 words? check for WWWOFFLE, '404/Not Found' pages
        if [[ "${W[1]}" -lt 4500 ]] && \
            [[ -n $(grep -i -l -E "(WWWOFFLE)|\
                (HTTP 40[0-9])|\
                (Not Found.*404)|\
                (404.*Not Found)|\
                (Error.*40[34])|\
                (40[34].*Error)|\
                (Page Not Found)|\
                (Pagina non trovata)" ${B}.cl ) ]]
        then
            let gfof++
            echo "${fid} err:g404 ${W[0]} ${W[1]} ${W[2]}" >> $FILELIST.no
            continue
        fi

        URL=$(awk '/^URL:/ { print $2; }' < ${B}.log | tail -n 1)
        if [ "${URL:0:4}" = "http" ]
        then
            let cnt++
            echo "${fid} $URL" >> $FILELIST
        else
            echo "${fid} err:url ${W[0]} ${W[1]} ${W[2]} $URL" >> $FILELIST.no
        fi
    else
        echo "${fid} sz: " >> $FILELIST.no

        if [[ "${W[1]}" -le $WRDS ]] 
        then
            let lt++
            echo -n "le " >> $FILELIST.no
        elif [[ ${W[0]} -le $LNS ]]
        then
            let ln++
            echo -n "ln " >> $FILELIST.no
        elif [[ "${W[2]}" -ge $CHRS ]]
        then
            let gt++
            echo -n "ge " >> $FILELIST.no
        fi 
        echo "${W[0]} ${W[1]} ${W[2]} ${URL}" >> $FILELIST.no
    fi
done

echo
echo -e "$cnt ($(( 100 * $cnt / $log ))%) files selected:\n $nlog ($(( 100 * $nlog / $log ))%) incomplete\n $lt/$gt/$ln ($(( 100 * $lt / $log ))%/$(( 100 * $gt / $log))%/$(( 100 * $ln / $log))%) too small/large/short\n $pfof/$gfof ($(( 100 * $pfof / $log ))%/$(( 100 * $gfof / $log))%) not200/g404,etc. errors"
