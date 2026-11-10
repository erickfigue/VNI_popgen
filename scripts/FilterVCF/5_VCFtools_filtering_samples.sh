#!/bin/bash

source /home/efigueroa/programs/miniforge3/etc/profile.d/mamba.sh
mamba activate popgen

filtering_samples(){
	local VCF=$1
	local FN=$2
    local OUT_DIR=$3
    local samples=$4

    OUT="${OUT_DIR}/${FN}_filtered_samples"

	vcftools --gzvcf $VCF \
	--remove $samples \
	--out $OUT \
	--recode --recode-INFO-all \
	--stdout | bgzip -c > $OUT".vcf.gz"

	tabix $OUT".vcf.gz"
}

OUT_DIR=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/6_final_VCFs/maf0/maskedHet
VCF=072826_VNI_x1729_snps_filtered_maskedHet_m10_filtered_samples_ann.vcf.gz
samples=remove_outliers.txt
FN="073026_VNI_x1727_snps_filtered_maskedHet_m10_filtered_samples_ann" ## I'm removing samples with missing data > 10%, after AD1 filtering 

# Run the function 1
filtering_samples $VCF $FN $OUT_DIR $samples
