
# This file is part of a minor variant calling pipeline.
# Copyright (C) 2015   George Githinji  <ggithinji@kemri-wellcome.org>

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

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


