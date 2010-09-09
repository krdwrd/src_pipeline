#!/bin/bash

export LANG=en_US.UTF-8
RETRIES=3
USEFOLLOW="-f" # ""
USEJS="" # "-j"
USEPROXY="" # "-p host:port" or "-p \"\""
NOPIC="-s" # ""
USEGRID="" # "-g"

function usage
{
    echo -e "Usage: $(basename $0)" \
        "file1.urls ..." \
        "(list of files of url lists ending in .urls) \n\
Wrapper for $(dirname $0)/grab.sh: Grab URLs listed in files.\n\
(See the beginning of the file for some parameters you might want to change.)
\n\
    status output:
         c:apitulated
         f:ailed
         k:illed
         l:ocked
         .:found in inital sweep - file existed then
         *:xists - recently added
         +:success"
    exit 1
}

while getopts ":h" opt
do
    case $opt in
        h|\?) usage
            ;;
    esac
done
shift $(($OPTIND - 1))

function cleanup
{
    if [ -n ${FN} ]
    then
        echo cleaning up...
        # if [ -e ${LOG} ]; then rm -v ${LOG}; fi
        if [ -e ${FN} ]; then rm -v ${FN}; fi
        if [ -e ${FN}.awk ]; then rm -v ${FN}.awk; fi
        if [ -e ${FN}.lock ]; then rmdir -v ${FN}.lock; fi
    fi
    exit
}

function settrap
{
    trap cleanup INT TERM
}

for g in $@
do
    echo $g

    i=0
    cat=$(basename $g .urls)

    # create directory for the output files
    [ -d ${cat} ] || mkdir ${cat} || exit 1
    
    # build a list of already processed files for later look-up
    processed=
    for num in \
        $(sort \
        <(seq -f "%05g" 1 $(( $(wc -l $g | cut -d ' ' -f1) )) ) \
        <(find ./${cat}/ -maxdepth 1 -name '*.gold' -printf '%f\n' 2>/dev/null | sed -e 's#\.gold##') | uniq -d | sed -e 's#^0\+##')
    do
        processed[${num}]=y
    done

    settrap

    for url in $(cat $g)
    do
        let i++

        # be verbose from time to time - print acutal file and count
        if ! (( $i % 5000 ))
        then 
            echo -e "\n${cat}/${i}"
        fi

        # look up current file in built list - and skip if already seen...
        [ -n "${processed[${i}]}" ] && echo -n "." && continue

        printf -v ind "%05d" $i
        FN=${cat}/${ind}.gold
        LOG=${cat}/${ind}.log

        # skip if file exists
        # skip if too many tries
        # create lock while processing
        if [[ -f $FN ]]
        then
            echo "DATE: "$(date) >> $LOG
            echo "EXISTS" >> $LOG
            # exists
            echo -n "*"
            continue
        elif [[ -f $LOG && $(grep -cE "^FAILED( - .)?$" ${LOG}) -ge ${RETRIES} ]]
        then 
            # capitulated
            echo -n "c"
            continue
        else
            if mkdir ${FN}.lock > /dev/null 2>&1
            then
                echo "DATE: "$(date) >> $LOG
            else
                # locked
                echo -n "l"
                continue
            fi
        fi
        
        # download
        #echo $(dirname $0)/pipe.sh $USEGRID $USEFOLLOW $USEJS $USEPROXY $NOPIC "$url" $(pwd)/$cat/$ind
        $(dirname $0)/app/pipe.sh $USEGRID $USEFOLLOW $USEJS $USEPROXY $NOPIC "$url" $(pwd)/$cat/$ind 1>&1 >> $LOG
        _RES=$?

        # this gives us the URL as the app printed it
        APPURL=$(awk '/URL:/ { print $2; }' $LOG | tail -n 1 | sed 's|^\(.*/\).*$|\1|')

        # remove lock
        rmdir ${FN}.lock
        
        if [[ ${_RES} != 0 || ! -f $FN ]]
        then
            echo "NOT: '$url'" >> $LOG
            echo -n "FAILED" >> $LOG

            if [ ${_RES} = 10 ]
            then 
                # timeout -> killed
                echo -n "k"
                echo " - k" >> $LOG
            elif [ ${_RES} = 20 ]
            then
                # failed
                echo -n "f"
                echo " - f" >> $LOG
            elif [ ${_RES} = 30 ] 
            then
                # stopped - page load timeout
                echo -n "s"
                echo " - s" >> $LOG
            else
                # unknown failure
                echo -n "u"
                echo " - u" >> $LOG
            fi
            continue
        fi
        echo "DONE" >> $LOG
        echo -n "+"
    done
    echo
done
