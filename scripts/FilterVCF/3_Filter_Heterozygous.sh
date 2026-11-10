#!/bin/bash

source /home/efigueroa/programs/miniforge3/etc/profile.d/mamba.sh
mamba activate popgen

### This script change to missing data the genotypes that are heterozygous
### 

## VCF with no MAF filter
FN1="072726_VNI_x1758_snps_filtered"  ## Filename prefix
VCF1="/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/4_vcftools_filtering/1_snps_filtering/072126_VNI_x1758_snps_2all_dp5_miss0.9_mac0_minGQ30.vcf.gz"
OUT1=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/5_AD_filtering/1_noHet

cd ${OUT1}

#bcftools +setGT $VCF1 \
#    -- -t q -n . -i 'GT="1/0" || GT="1|0" || GT="0/1" || GT="0|1"' \
#| bgzip > $FN1"_noHet.vcf.gz"

bcftools +setGT $VCF1 \
    -- -t q -n . -i 'GT="het"' \
| bgzip > $FN1"_maskedHet.vcf.gz"

tabix $FN1"_maskedHet.vcf.gz"