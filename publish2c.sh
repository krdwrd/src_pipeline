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

for i in $(find $(dirname ${SRC})/$(basename ${SRC})/ -name '*.log' -printf '%f\n' | sort -n)
do
    let log++

    # be verbose about progress every now and then
    if ! (( $log % 5000 )); then echo -n "${log} "; fi

    fid=${i%.log}
    B=${SRC}/${fid}

    # check for the output files of an app run - without these we need not proceed
    [ -e ${B}.gold ] && [ -e ${B}.cl ] && [ -e ${B}.txt ] && [ -e ${B}.dom ] && [ -e ${B}.bte ] && [ -e ${B}.xy2 ] || \
    { 
        let nlog++
        echo "${fid} not:A" >> $FILELIST.no
        continue
    }
   
    # put wc's output into an array
    W=( $(wc -w -m < $B.cl) )
    
    # file has > 1000 characters? then consider it
    if [[ "${W[1]}" -gt 500 ]]
    then
        # file has < 5000 words? then check for WWWOFFLE, 404, etc pages
        if [[ "${W[0]}" -lt 4500 ]]
        then
            [ -z $(grep -l -E "(WWWOFFLE)|\
                (Not Found.*404)|\
                (404.*Not Found)|\
                (Error.*404)|\
                (404.*Error)|\
                (Page Not Found)" ${B}.cl ) ] || \
            {
                let lt++
                echo "${fid} err:404 ${W[0]} ${W[1]}" >> $FILELIST.no
                continue
            }
        
                # file has > 200.000 chars? (~200kB) then skip it
        elif [[ "${W[1]}" -gt 10000 ]]
        then
            echo "${fid} gt: ${W[0]} ${W[1]}" >> $FILELIST.no
            let gt++
            continue
        fi

        URL=$(awk '/^URL:/ { print $2; }' < ${B}.log | tail -n 1)
        if [ "${URL:0:4}" = "http" ]
        then
            let cnt++
            echo "${fid} $URL" >> $FILELIST
        else
            echo "${fid} err:url ${W[0]} ${W[1]} $URL" >> $FILELIST.no
        fi
    else
        echo "${fid} lt: ${W[0]} ${W[1]}" >> $FILELIST.no
        let lt++
    fi
done

echo
echo -e "$cnt ($(( 100 * $cnt / $log ))%) files selected:\n $nlog ($(( 100 * $nlog / $log ))%) incomplete\n $lt ($(( 100 * $lt / $log ))%) too small or 404\n $gt ($(( 100 * $gt / $log ))%) too large"
