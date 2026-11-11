#!/bin/bash

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

#source /home/efigueroa/miniforge3/etc/profile.d/conda.sh
#conda activate snippy

MarkDuplicates_funct(){
    local BAM=$1

    name=$(basename "${BAM}" | sed 's/.sorted\.bam//')
    
    echo "working on $name"

    OUT=${name}".marked_duplicates.bam"
    MET=${name}".marked_duplicates.metrics.txt"
    
    ### Mark duplicates
    gatk --java-options -Xmx8G MarkDuplicates \
        -I $BAM \
        -O $OUT \
        -M $MET 
}

## Execute the function

export -f MarkDuplicates_funct  # Make the function available to parallel

cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step4_mark_dup/mitogenome

BAMs=(/FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step3_merged_bam/mitogenome/*sorted.bam) ## Array of bam files

# Run in parallel (adjust -j for number of parallel jobs)
parallel -j 30 --joblog joblog.txt MarkDuplicates_funct ::: ${BAMs[@]}  > MarkDup_output.log 2>&1 
