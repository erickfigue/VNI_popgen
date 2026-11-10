#!/bin/bash

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

#source /home/efigueroa/miniforge3/etc/profile.d/conda.sh
#conda activate snippy

MarkAdapters(){
    local BAM=$1
    name=$(basename "${BAM}" | sed 's/_unaligned_read_pairs\.bam//')

    echo "working on $name"

    gatk --java-options -Xmx4G MarkIlluminaAdapters \
        -I $BAM \
        -O ${name}"_markadapters.bam" \
        -M ${name}"_mark_adapters_metrics.txt" \
        --TMP_DIR `pwd`/tmp
    
    echo "done with $name"
}

## Execute the function
export -f MarkAdapters  # Make the function available to parallel

# Run in parallel (adjust -j for number of parallel jobs)
cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step2_mark_adapters/mitogenome

BAMs=(/FastData/efigueroa/fastq_processing/mapping_gatk_variants/Step1_ubam/mitogenome/*.bam)

parallel -j 15 --joblog joblog.txt MarkAdapters ::: ${BAMs[@]} > MarkAdapters_output.log 2>&1
