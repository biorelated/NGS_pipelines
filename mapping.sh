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
# 1. SMALT or BWA
# 2. sambamba
# 3. samtools 

# This software uses multithreading where applicable. Please ensure that adequate memory 
# is available otherwise adjust or remove the multithreading features. 

#!/bin/bash

USAGE="Usage: $0 -p reference -f fastq_1 -r fastq_2 -m [bwa | smalt] [-k wordlength -s samplingstep] -o outputdir"

while getopts p:f:r:m:k:s:o:h opt
do
    case "$opt" in
        p) REF="$OPTARG";;
        f) FASTQ1="$OPTARG";;
        r) FASTQ2="$OPTARG";;
        m) MAPPER="$OPTARG";;
        k) WORD_LENGTH="$OPTARG";;
        s) SAMPLING_STEP="$OPTARG";;
        o) OUTPUT_DIR="$OPTARG";;
        h) echo $USAGE
            exit 1;;
    esac
done


if [[ $MAPPER == "" || $REF == "" || $FASTQ1 == "" || $FASTQ2 == "" || $OUTPUT_DIR == "" ]]; then
    echo $USAGE
    exit 0
fi

#check that the dependencies are installed and available on the $PATH
command -v smalt    >/dev/null 2>&1 || { echo >&2 "smalt is not installed.  Aborting."; exit 1;    }
command -v sambamba >/dev/null 2>&1 || { echo >&2 "sambamba is not installed.  Aborting."; exit 1; }
command -v samtools >/dev/null 2>&1 || { echo >&2 "samtools is not installed.  Aborting."; exit 1; }


REFFILENAME="$(basename $REF)"
REFNAME="${REFFILENAME%.*}"

SAMPLEBASENAME="$(basename $FASTQ1)"
SAMPLENAME="${SAMPLEBASENAME%%.*}"

echo "processing $SAMPLENAME"

if [[ $MAPPER == "bwa" ]]
then
    echo "$REFNAME"
    echo "mapping reads with $MAPPER"

elif [[ $MAPPER == "smalt" ]]

    if [[ $WORD_LENGTH == "" || $SAMPLING_STEP == "" ]]; then
        echo "Missing  parameter(s) -k wordlength -s sampling step "
        exit 0
    fi
then
    mkdir -p "$OUTPUT_DIR/$SAMPLENAME"

    echo "building index  with $MAPPER"
    smalt index -k "$WORD_LENGTH" -s "$SAMPLING_STEP" "$OUTPUT_DIR/$SAMPLENAME/$REFNAME$WORD_LENGTH$SAMPLING_STEP" "$REF"

    echo "mapping reads"
    smalt map -n 16 -O -x -f bam -o "$OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.bam" "$OUTPUT_DIR/$SAMPLENAME/$REFNAME$WORD_LENGTH$SAMPLING_STEP" "$FASTQ1" "$FASTQ2"
fi

echo "sorting bam file"
sambamba sort --nthreads 16 --show-progress "$OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.bam" --out "$OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.sorted.bam"

echo "indexing bam file with sambamba"
sambamba index --nthreads 16 --show-progress "$OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.sorted.bam" "$OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.sorted.bam.bai"

echo "writing flagstats"
sambamba flagstat --nthreads 16 --show-progress "$OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.sorted.bam" >$OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.flagstat

echo "generating mpileup"
#samtools faidx $REF >$OUTPUT_DIR/$SAMPLENAME/$REFNAME.faidx.fa
samtools mpileup --fasta-ref $REF $OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.sorted.bam --output $OUTPUT_DIR/$SAMPLENAME/$SAMPLENAME.$REFNAME.mpileup
echo "done!"
