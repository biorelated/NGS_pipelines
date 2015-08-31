#!/bin/bash

USAGE="Usage: $0 -p reference -f fastq_1 -r fastq_2 -m [bwa | smalt] [-k wordlength -s samplingstep]"

while getopts p:f:r:m:k:s:h opt
do
    case "$opt" in
        p) REF="$OPTARG";;
        f) FASTQ1="$OPTARG";;
        r) FASTQ2="$OPTARG";;
        m) MAPPER="$OPTARG";;
        k) WORD_LENGTH="$OPTARG";;
        s) SAMPLING_STEP="$OPTARG";;
        h) echo $USAGE
            exit 1;;
    esac
done

if [[ $MAPPER == "" || $REF == "" || FASTQ1 == "" || FASTQ2 == "" ]]; then
    echo $USAGE
    exit 0
fi

if [[ $MAPPER == "bwa" ]]
then

    echo "mapping reads with $MAPPER"

elif [[ $MAPPER == "smalt" ]]
    
    if [[ $WORD_LENGTH == "" || $SAMPLING_STEP == "" ]]; then
        echo "Missing SMALT's hashing parameters -k and -s "
        exit 0
    fi
then

    echo "mapping with $MAPPER"
fi



#smalt map -f bam -o sample_reference.bam reference reads_1 reads_2

