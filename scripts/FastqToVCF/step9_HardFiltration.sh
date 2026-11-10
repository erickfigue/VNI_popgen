#!/bin/bash

export PATH="/FastData/efigueroa/programs/gatk-4.6.2.0/:$PATH"
export JAVA_HOME=/FastData/efigueroa/programs/jdk-17.0.12
export PATH=$JAVA_HOME/bin:$PATH

#source /home/efigueroa/miniforge3/etc/profile.d/conda.sh
#conda activate snippy

HardFiltration(){
    local REF=$1
    local FN=$2
    local VCF=$3

    ### Select variants, raw SNPs and Indels. Mixed are discarded
    gatk --java-options -Xmx32G SelectVariants \
        -V $VCF \
        -R $REF \
        -select-type SNP -O $FN"_snps.vcf.gz"
    
        gatk --java-options -Xmx32G SelectVariants \
        -V $VCF \
        -R $REF \
        -select-type INDEL -O $FN"_indels.vcf.gz"

    ## Hard filter variants, different parameters for Indels and SNPs. GATK recommendations. Considering MQRankSum and ReadPosRankSum
    gatk --java-options -Xmx32G VariantFiltration \
        -V $FN"_snps.vcf.gz" \
        -R $REF \
        -filter "QD < 2.0" --filter-name "QD2" \
        -filter "QUAL < 30.0" --filter-name "QUAL30" \
        -filter "SOR > 3.0" --filter-name "SOR3" \
        -filter "FS > 60.0" --filter-name "FS60" \
        -filter "MQ < 40.0" --filter-name "MQ40" \
        -filter "MQRankSum < -12.5" --filter-name "MQRS12.5" \
        -filter "ReadPosRankSum < -8.0" --filter-name "RPRS8" \
        -O $FN"_snps_HF_tagged.vcf.gz"

    gatk --java-options -Xmx32G VariantFiltration \
        -V $FN"_indels.vcf.gz" \
        -R $REF \
        -filter "QD < 2.0" --filter-name "QD2" \
        -filter "QUAL < 30.0" --filter-name "QUAL30" \
        -filter "FS > 200.0" --filter-name "FS200" \
        -filter "ReadPosRankSum < -20.0" --filter-name "RPRS20" \
        -O $FN"_indels_HF_tagged.vcf.gz"

    ## Combine filtered SNPs and Indels

    gatk --java-options -Xmx16G MergeVcfs \
        -R $REF \
        -I $FN"_snps_HF_tagged.vcf.gz" \
        -I $FN"_indels_HF_tagged.vcf.gz" \
        -O $FN"_variants_HF_tagged.vcf.gz"

}

## Variants in previous step are tagged, the next step will remove those variants not passing the filters

Filter_HF(){
    local FN=$1
    local VCF=$2

    gatk --java-options -Xmx32G SelectVariants \
        -V $VCF \
        --exclude-filtered \
        -O $FN"_HardFiltered.vcf.gz"
}

## Execute the function

cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/2_HardFiltration

REF=/FastData/efigueroa/fastq_processing/reference/VNI.fasta
FN="071526_VNI_x1758"
VCF="/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/1_joint_genotyping/071026_VNI_x1758_genotyped_gvcfs.vcf.gz"

HardFiltration $REF $FN $VCF > HardFiltration_output.log 2>&1

Filter_HF $FN"_snps" $FN"_snps_HF_tagged.vcf.gz" > SNPs_HardFiltration.log 2>&1
Filter_HF $FN"_indels" $FN"_indels_HF_tagged.vcf.gz" > Indels_HardFiltration.log 2>&1
Filter_HF $FN"_variants" $FN"_variants_HF_tagged.vcf.gz" > Variants_HardFiltration.log 2>&1
