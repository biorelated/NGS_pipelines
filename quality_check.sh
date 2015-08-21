#!/bin/bash

DATA_DIR=../data/
FASTQC_DIR=../results/fastqc
THREADS=10

#run fastqc 
echo "Running fastqc with $THREADS threads"
find $DATA_DIR \( -name '*.fastq.gz' \) -print0 | xargs -0 fastqc --outdir $FASTQC_DIR --threads 10 --nogroup --extract 

#cleanup
echo "Cleaning up"
rm $FASTQC_DIR/*.html $FASTQC_DIR/*.zip
rm $FASTQC_DIR/**/*.html $FASTQC_DIR/**/*.fo $FASTQC_DIR/**/summary.txt $FASTQC_DIR/**/Images $FASTQC_DIR/**/Icons


find $FASTQC_DIR -type d -exec mv -nv -- {}/fastqc_data.txt {}.txt \; -empty -delete

#run crimson
#find $FASTQC_DIR \( -name 'fastqc_data.txt' \) -print0 | xargs -0 crimson fastqc 
