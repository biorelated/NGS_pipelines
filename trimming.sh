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

# Dependencies
# 1. Trimmomatics

#/bin/bash

USAGE="Usage: $0 -i inputdir -t threads -l logfile -o output_dir -h help"

while getopts i:o:h opt
do
    case "$opt" in
        i) INPUTDIR="$OPTARG";;
        o) OUTDIR="$OPTARG";;
        h) echo $USAGE
            exit 1;;
    esac
done

#if [[ $FASTQ1 == "" || $FASTQ2 == "" || $OUTDIR == "" ]]; then
 #   echo $USAGE
  #  exit 0
#fi

#command -v java -jar ~/bin/trimmomatic.jar >/dev/null 2&1 || { echo >&2 "Trimmomatic is not installed. Aborting"; exit 1; }


find $INPUTDIR -type d -exec sh -c '(cd {} dirname=$(basename "$PWD") && java -jar ~/bin/trimmomatic.jar PE -threads 10 -phred33 -trimlog $(basename "$PWD").log *.f.fastq.gz *.r.fastq.gz $(basename "$PWD").1P.fastq.gz $(basename "$PWD").1U.fastq.gz $(basename "$PWD").2P.fastq.gz $(basename "$PWD").2U.fastq.gz SLIDINGWINDOW:10:20 MINLEN:140 )' ';'


#for filename in $INPUTDIR*/*.trimmed*.*
#do
#    foldername=$(basename ${filename%.*.*.*})
#    newname=$(basename ${filename%.*.*})
#    mkdir -p "$OUTDIR/$foldername"
#    mv "$filename" "$OUTDIR/$foldername/$newname.fastq.gz"
#done

