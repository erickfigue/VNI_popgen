#!/bin/bash

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

#source /home/efigueroa/miniforge3/etc/profile.d/conda.sh
#conda activate snippy

HaplotypeCaller_funct(){
    local BAM=$1

    name=$(basename "${BAM}" | sed 's/\.reordered.bam//')
    
    echo "working on $name"

    OUT=${name}".g.vcf.gz"
    
    ### HaplotypeCaller
    gatk --java-options -Xmx16G HaplotypeCaller \
        -R $REF \
        -I $BAM \
        -O $OUT \
        -ERC GVCF \
        -ploidy 2

}

## Execute the function

REF=/FastData/efigueroa/fastq_processing/reference/VNI.fasta

export REF # Export the reference path to be used in the function
export -f HaplotypeCaller_funct  # Make the function available to parallel

cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step6_diploid_gvcfs/VNI_NC/newest_samples/

BAMs=(/FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step5_final_bams/VNI_NC/newest_samples/*.reordered.bam) ## Array of bam files

# Run in parallel (adjust -j for number of parallel jobs)
parallel -j 25 --joblog joblog.txt HaplotypeCaller_funct ::: ${BAMs[@]}  > HapCaller_output.log 2>&1 
