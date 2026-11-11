#!/bin/bash
set -euo pipefail
# stop on the first error,
# complain if you use undefined variables,
# treat pipeline failures correctly.

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

#source /home/efigueroa/miniforge3/etc/profile.d/conda.sh
#conda activate snippy

CombineGVCFs_funct(){
    
    OUT=$OUTFILE ## Output file name

    # Build the --variant arguments
    variant_args=()
    for vcf in "$@"; do
        variant_args+=( --variant "$vcf")
    done


    ### Combine GVCFs
    gatk --java-options -Xmx32G CombineGVCFs  \
        -R "$REF" \
        -O "$OUT" \
        "${variant_args[@]}"
        
}

## Execute the function

REF=/FastData/efigueroa/fastq_processing/reference/VNI.fasta

cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_VNII_VNB/1_joint_genotyping

vcf_files=(/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_VNII_VNB/gvcfs/*g.vcf.gz) ## Array of gvcf files
OUTFILE="071526_VNI_VNII_VNB_combined_gvcfs.vcf.gz"

CombineGVCFs_funct ${vcf_files[@]} > CombineGVCFs_VNI_VNII_VNB_output.log 2>&1
