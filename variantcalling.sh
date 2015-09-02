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
# 1. VPhaser2
# 2. FreeBayes
# 3. QUASR

# This software uses multithreading where applicable. Please ensure that adequate memory 
# is available otherwise adjust or remove the multithreading features. 


#!/bin/bash

USAGE="USAGE: $0 -b bamfile -o outputdir -c [vphaser2 | quasr | freebayes] -h help"

while getopts b:c:o:h opt
do
    case "$opt" in
        b) BAMFILE="$OPTARG";;
        o) OUTDIR="$OPTARG";;
        c) CALLER="$OPTARG";;

        h) echo $USAGE
            exit 1;;
    esac
done

if [[ $CALLER == "" || $OUTDIR == "" || $BAMFILE == "" ]]; then
    echo $USAGE
    exit 0
fi

SAMPLEBASENAME="$(basename $BAMFILE)"
SAMPLENAME="${SAMPLEBASENAME%%.*}"


#check dependencies are on the $PATH
command -v VPhaser2 >/dev/null 2>&1 ||{ echo >&2 "VPhaser2 is not installed. Aborting..."; exit 1;  }


if [[ $CALLER == "vphaser2"  ]]; then
    echo "calling minority variants with $CALLER"

    mkdir -p "$OUTDIR/$SAMPLENAME"

    #run with explicit vphaser2 parameters. 
    #See the vphaser2 manual for description(http://www.broadinstitute.org/software/viral/docs/VPhaserII.pdf)
   OMP_NUM_THREADS=16 VPhaser2 -i "$BAMFILE" -o "$OUTDIR/$SAMPLENAME" -e 1 -w 500 -ig 0 -delta 2 -ps 30 -dt 1 -cy 1 -mp 1 -qual 20 -a 0.05

fi







