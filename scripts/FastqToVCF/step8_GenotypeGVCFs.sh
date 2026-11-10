#!/bin/bash

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

#source /home/efigueroa/miniforge3/etc/profile.d/conda.sh
#conda activate snippy

GenotypeGVCFs_funct(){
    local REF=$1
    local OUT=$2
    local comb_vcf=$3

    ### Genotype GVCFs
    gatk --java-options -Xmx32G GenotypeGVCFs \
        -R $REF \
        -O $OUT \
        -V $comb_vcf
        
}

## Execute the function

cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_VNII_VNB/1_joint_genotyping

REF=/FastData/efigueroa/fastq_processing/reference/VNI.fasta
OUT="072026_VNI_VNII_VNB_genotyped_gvcfs.vcf.gz" ## Output file name
comb_vcf=071526_VNI_VNII_VNB_combined_gvcfs.vcf.gz

GenotypeGVCFs_funct $REF $OUT $comb_vcf > GenotypeGVCFs_VNI_VNII_VNB_output.log 2>&1
