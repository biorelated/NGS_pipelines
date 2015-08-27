#!/bin/bash

#Dependencies
# 1) QUASR (https://github.com/sanger-pathogens/QUASR)


while getopts i:d:h o
do
    case "$o" in
        i) DATA_DIR="$OPTARG";;
        d) OUT_DIR="$OPTARG";;
        h) echo $USAGE
            exit 1;;
    esac
done

if [[ $DATA_DIR == "" || $OUT_DIR == "" ]]; then
    echo "Usage: $0 -i data_dir -d out_dir "
    exit 0
fi

mkdir -p $OUT_DIR

find $DATA_DIR -type d -exec sh -c '(cd {} && java -jar ~/softwares/quasr_dist/readsetProcessor.jar --duplicate --gzip --num 1000 -i *_1.fastq.gz -r *_2.fastq.gz  --outprefix $OUT_DIR noduplicates >>deduplication.log)' ';'


