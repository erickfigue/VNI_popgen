#!/bin/bash

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

source /home/efigueroa/programs/miniforge3/etc/profile.d/mamba.sh
mamba activate readmap_varcall

SamFastqAlignMerge(){
    local BAM=$1

    name=$(basename "${BAM}" | sed 's/_markadapters\.bam//')
    
    echo "working on $name"
    UNMAP=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step1_ubam/mitogenome/${name}"_unaligned_read_pairs.bam"
    OUT1=${name}".readgroups_unmapped.bam"
    OUT2=${name}".sorted.bam"
    read_group="@RG\tID:FLOWCELL_${name}\tSM:${name}\tPL:ILLUMINA\tLB:LIB_${name}"   
  
    ### Assign RG to all unmapped reads. This is overwritting the read groups in the unaligned bam file
    gatk --java-options -Xmx8G AddOrReplaceReadGroups \
        -I $UNMAP \
        -O $OUT1 \
        -ID FLOWCELL_$name \
        -LB LIB_$name \
        -PL ILLUMINA \
        -SM $name \
        -PU unit1 

    ### SamtoFastq piped to bwa mem and MergeBamAlignment
    ## samtools view -1 is used to convert SAM to BAM format fast. 
    ## samtools view -b is slower but the same. Did not work with -1
    gatk --java-options -Xmx8G SamToFastq \
        -I $BAM \
        --FASTQ /dev/stdout \
        -CLIP_ATTR XT -CLIP_ACT 2 -INTER true -NON_PF true | \
    bwa mem -M -R $read_group -p $REF /dev/stdin | \
    samtools view -b | \
    gatk --java-options -Xmx16G MergeBamAlignment \
    -ALIGNED /dev/stdin \
    -UNMAPPED $OUT1 \
    -O $OUT2 \
    -R $REF

}

## Execute the function
REF=/FastData/efigueroa/fastq_processing/reference/VNI_mt/VNI_mt.fa

export REF # Export the reference path to be used in the function
export -f SamFastqAlignMerge  # Make the function available to parallel

## Update paths
cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step3_merged_bam/mitogenome

BAMs=(/FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step2_mark_adapters/mitogenome/*.bam) ## Array of bam files

# Run in parallel (adjust -j for number of parallel jobs)
parallel -j 15 --joblog joblog.txt SamFastqAlignMerge ::: ${BAMs[@]}  > SamFastqAlignMerge_output.log 2>&1 
