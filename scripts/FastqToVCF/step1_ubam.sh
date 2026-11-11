#!/bin/bash

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

## Defining function to convert fastq files to unaligned bam files
# First argument is R1 fastq file
# Edit according to your fastq file extension
# Modify path for R2 files if needed
FatqUbam(){
        local R1=$1

        NAME=$(basename "${R1}" | sed 's/_R1\.fq\.gz//') 
        R2="/FastData/efigueroa/fastq_processing/fastq/all_VNI_fastq/"$NAME"_R2.fq.gz" 

        if [ ! -e "$R2" ]; then
                echo "Missing R2 for $NAME" >&2
                return 1
        fi

        echo "working on $NAME"
        OUT=$NAME"_unaligned_read_pairs.bam"
        
        gatk --java-options -Xmx2g FastqToSam \
                F1=$R1 \
                F2=$R2 \
                O=$OUT \
                RG=$NAME \
                SM=$NAME \
                TMP_DIR=`pwd`/tmp
        
        echo "done with $NAME"
}

## Execute the function
export -f FatqUbam  # Make the function available to parallel

# Entering directory to store unaligned bam files
cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step1_ubam/mitogenome

# Array of R1 fastq files
R1S=(/FastData/efigueroa/fastq_processing/fastq/all_VNI_fastq/*_R1.fq.gz)

# Run in parallel (adjust -j for number of parallel jobs)
parallel -j 15 --joblog joblog.txt FatqUbam ::: ${R1S[@]} > FatqUbam_output.log 2>&1 
