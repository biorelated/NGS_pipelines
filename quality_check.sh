#!/bin/bash

#Dependencies
#  1) fastqc
#  2) crimson


while getopts d:f:t:h o
do
    case "$o" in
        d) DATA_DIR="$OPTARG";;
        f) FASTQC_DIR="$OPTARG";;
        t) THREADS="$OPTARG";;
        h) echo $USAGE
            exit 1;;
    esac
done

if [[ $DATA_DIR == "" || $FASTQC_DIR == "" || $THREADS == "" ]]; then
    echo "Usage: $0 -d data_dir -f results_dir -t threads "
    exit 0
fi

mkdir -p $FASTQC_DIR

export DISPLAY=:0.0

#run fastqc 
echo "Running fastqc with $THREADS threads"
find $DATA_DIR \( -name '*.fastq.gz' \) -print0 | xargs -0 fastqc --outdir $FASTQC_DIR --threads $THREADS --nogroup --extract 

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

