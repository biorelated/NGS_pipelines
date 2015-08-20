#!/bin/bash

DATA_DIR=../data/
FASTQC_DIR=../results/fastqc
THREADS=10

#run fastqc 
echo "Running fastqc with $THREADS "
find $DATA_DIR \( -name '*.fastq.gz' \) -print0 | xargs -0 fastqc --outdir $FASTQC_DIR --threads 10 --nogroup --extract 

#cleanup
echo "Cleaning up"
rm $FASTQC_DIR/*.html $FASTQC_DIR/*.zip

#rename the fastqc_data dump. That is all we care about!
rm $FASTQC_DIR/**/*.html $FASTQC_DIR/**/*.fo $FASTQC_DIR/**/summary.txt $FASTQC_DIR/**/Images $FASTQC_DIR/**/Icons

#run crimson
#find $FASTQC_DIR \( -name 'fastqc_data.txt' \) -print0 | xargs -0 crimson fastqc 
