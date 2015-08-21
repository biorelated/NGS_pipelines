#!/bin/bash

##Make this script safe!
DATA_DIR=../data/
FASTQC_DIR=../results/fastqc
THREADS=10

#run fastqc 
echo "Running fastqc with $THREADS threads"
find $DATA_DIR \( -name '*.fastq.gz' \) -print0 | xargs -0 fastqc --outdir $FASTQC_DIR --threads 10 --nogroup --extract 

#keep fastqc data files only
echo "mopping up extra files."
rm $FASTQC_DIR/*.html $FASTQC_DIR/*.zip
rm -r $FASTQC_DIR/**/*.html $FASTQC_DIR/**/*.fo $FASTQC_DIR/**/summary.txt $FASTQC_DIR/**/Images $FASTQC_DIR/**/Icons

#rename each fastqc_data.txt based on parent directory. 
find "$FASTQC_DIR" -type d -exec mv  -- {}/fastqc_data.txt {}.txt \; -empty -delete

cd $FASTQC_DIR

#convert fastqc_data file to json
for file in *.txt; do
    crimson fastqc $file >${file/%.txt/.json}; 
done

rm -f *.txt

cd -

echo "Done!"

