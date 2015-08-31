#!/bin/bash

#Dependencies
# 1) QUASR (https://github.com/sanger-pathogens/QUASR)

#  Command line paramaters
while getopts i:o:h opt
do
    case "$opt" in
        i) DATA_DIR="$OPTARG";;
        o) OUT_DIR="$OPTARG";;
        h) echo $USAGE
            exit 1;;
    esac
done

if [[ $DATA_DIR == "" || $OUT_DIR == "" ]]; then
    echo "Usage: $0 -i data_dir -o out_dir "
    exit 0
fi


# function updateFolder
# {
#     mkdir "$2"
#     for folder in "$1"/*; do
#         if [[ -d $folder ]]; then
#             foldername="${folder##*/}"
#             for file in "$1"/"$foldername"/*; do
#                 filename="${file##*/}"
#                 newfilename="$foldername"_"$filename"
#                 cp "$file" "$2"/"$newfilename"
#             done
#         fi
#     done
# }

mkdir -p $OUT_DIR

# run the deduplication command
find $DATA_DIR -type d -exec sh -c '(cd {} && java -jar ~/softwares/quasr_dist/readsetProcessor.jar --duplicate --gzip --num 1000 -i *_1.fastq.gz -r *_2.fastq.gz  --outprefix $(basename "$PWD") >>deduplication.log)' ';'

for full_filename in $DATA_DIR*/*.uniq.*
do
    foldername=$(basename ${full_filename%.*.*.*.*})
    newname=$(basename ${full_filename%.*.*})
    mkdir -p "$OUT_DIR/$foldername"
    mv "$full_filename" "$OUT_DIR/$foldername/$newname.fastq.gz"
done


