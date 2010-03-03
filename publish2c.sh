#!/bin/bash

if [[ -z "$1" || -z "$2" || -n "$3" ]]
then
 cat <<-EOH

Usage:
`basename $0` SOURCEDIR FILELISTNAME

create list of filenames' basename and URL of runpipe2c.sh pages in SOURCEDIR
EOH
 exit 1
fi

SRC=$1
FILELIST=$2
cnt=0
log=0
nlog=0
lt=0
gt=0

test -f $FILELIST && rm $FILELIST
test -f $FILELIST.no && rm $FILELIST.no

for i in $(find $(dirname ${SRC})/$(basename ${SRC})/ -name '*.log' | sort -n)
do
    let log++

    # be verbose about progress every now and then
    if ! (( $log % 5000 )); then echo -n "${log} "; fi

    B=${i%.log}
    # check for the output files of an app run - without these we need not proceed
    [ -e ${B}.gold ] && [ -e ${B}.cl ] && [ -e ${B}.txt ] && [ -e ${B}.dom ] && [ -e ${B}.bte ] && [ -e ${B}.xy2 ] || \
    { 
        let nlog++
        echo "${B##*/} $URL ${W[0]} ${W[1]} not:A" >> $FILELIST.no
        continue
    }
   
    # put wc's output into an array
    W=( $(wc -w -m < $B.cl) )
    
    # file has > 1000 characters? then consider it
    if [[ "${W[1]}" -gt 500 ]]
    then
        # file has < 5000 words? then check for WWWOFFLE, 404, etc pages
        if [[ "${W[0]}" -lt 5000 ]]
        then
            [ -z $(grep -l -E "(WWWOFFLE)|(Not Found.*404)|(404.*Not Found)|(Error.*404)|(404.*Error)" ${B}.cl ) ] || \
            {
                let lt++
                echo "${B##*/} $URL ${W[0]} ${W[1]} err:404" >> $FILELIST.no
                continue
            }
        
                # file has > 200.000 chars? (~200kB) then skip it
        elif [[ "${W[1]}" -gt 10000 ]]
        then
            echo "${B##*/} $URL ${W[0]} ${W[1]} gt:$W" >> $FILELIST.no
            let gt++
            continue
        fi

        URL=$(awk '/^URL:/ { print $2; }' < $i | tail -n 1)
        if [ "${URL:0:4}" = "http" ]
        then
            let cnt++
            echo "${B##*/} $URL" >> $FILELIST
        else
            echo "${B##*/} $URL ${W[0]} ${W[1]} err:url" >> $FILELIST.no
        fi
    else
        echo "${B##*/} $URL ${W[0]} ${W[1]} lt:${W[1]}" >> $FILELIST.no
        let lt++
    fi
done

echo
echo -e "$cnt ($(( 100 * $cnt / $log ))%) files selected:\n $nlog ($(( 100 * $nlog / $log ))%) incomplete\n $lt ($(( 100 * $lt / $log ))%) too small or 404\n $gt ($(( 100 * $gt / $log ))%) too large"
