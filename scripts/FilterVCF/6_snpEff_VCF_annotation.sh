#!/bin/bash

source /home/efigueroa/programs/miniforge3/etc/profile.d/mamba.sh
mamba activate popgen

# Paths
snpeff_config=/FastData/efigueroa/popgenomics/snp_eff/snpeff_data/VNI/snpEff.config 
datadir=/FastData/efigueroa/popgenomics/snp_eff/snpeff_data ## Folder where the VNI directory is located
VCF=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/5_AD_filtering/3_miss_data_sample/mac0/maskedHet/072826_VNI_x1758_snps_filtered_maskedHet_m10_filtered_samples.vcf.gz
FN=$(basename $VCF | sed -e 's/.vcf.gz//')
logfile=$FN"_snnpEff.log"

cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/6_final_VCFs/maf0/maskedHet

snpEff ann -v -classic VNI -config $snpeff_config -dataDir $datadir -stats $FN"_ann.html" $VCF > $FN"_ann.vcf" 2> $logfile 

bgzip $FN"_ann.vcf" 
tabix -p vcf $FN"_ann.vcf.gz"