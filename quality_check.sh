#!/bin/bash

DATA_DIR=../data/
FASTQC_DIR=../results/fastqc
THREADS=10

#run fastqc 
echo "Running fastqc with $THREADS "
find $DATA_DIR \( -name '*.fastq.gz' \) -print0 | xargs -0 fastqc --outdir $FASTQC_DIR --threads 10 --nogroup --extract --quiet

#cleanup
echo "Cleaning up"
rm $FASTQC_DIR/*.html $FASTQC_DIR/*.zip

for subdir in $QC_DIR; do 
    rm -r -f $subdir/*.fo $subdir/*.html $subdir/summary.txt $subdir/Images $subdir/Icons
done

#rename the fastqc_data dump. That is all we care about!
for subdir in $QC_DIR; do mv $subdir/fastqc_data.txt "$subdir".txt; done

#run crimson
#find $FASTQC_DIR \( -name '*.txt' \) -print0 | xargs -0 crimson fastqc 
