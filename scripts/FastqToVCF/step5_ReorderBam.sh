#!/bin/bash

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

#source /home/efigueroa/miniforge3/etc/profile.d/conda.sh
#conda activate snippy

ReorderBam(){
    local BAM=$1

    name=$(basename "${BAM}" | sed 's/\.marked_duplicates\.bam//')
    
    echo "working on $name"

    OUT=${name}".reordered.bam"
   
    ### Reorder Bam
    gatk --java-options -Xmx8G ReorderSam \
        -I $BAM \
        -O $OUT \
        -SD $REF 
        
    ### Index bam
    gatk --java-options -Xmx8G BuildBamIndex \
        -I $OUT

}

## Execute the function

REF=/FastData/efigueroa/fastq_processing/reference/VNI_mt/VNI_mt.fa

export REF # Export the reference path to be used in the function
export -f ReorderBam  # Make the function available to parallel

cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step5_final_bams/mitogenome

BAMs=(/FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step4_mark_dup/mitogenome/*.marked_duplicates.bam) ## Array of bam files

# Run in parallel (adjust -j for number of parallel jobs)
parallel -j 30 --joblog joblog.txt ReorderBam ::: ${BAMs[@]}  > ReorderBam_output.log 2>&1 
