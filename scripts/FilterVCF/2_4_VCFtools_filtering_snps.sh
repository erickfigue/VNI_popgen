#!/bin/bash

source /home/efigueroa/programs/miniforge3/etc/profile.d/mamba.sh
mamba activate popgen

vcftools_filtering(){
	local VCF=$1
	local FN=$2
    local OUT_DIR=$3
    local alleles=$4
    local mindp=$5
    local maxmiss=$6
    local minmaf=$7
	local GQ=$8

    OUT="${OUT_DIR}/${FN}_${alleles}all_dp${mindp}_miss${maxmiss}_mac${minmaf}_minGQ${GQ}"

	### This function filter a VCF file considering parameters to keep only biallelic SNPs, 
	### filter based on depth of coverage by site (average) and genotype (by sample), 
	### percent of missing data per variant,
	### minimum allele count or minor allele frequency, to filter using minor allele frequency MAF change --mac N to --maf percent 
	### Genotype Quality (GQ)
	### vcftools generates a log file with the criteria used so parameters can be explored after filtering
	vcftools --gzvcf $VCF \
	--min-alleles $alleles --max-alleles $alleles \
	--min-meanDP $mindp --minDP $mindp \
	--max-missing $maxmiss \
	--mac $minmaf \
	--minGQ $GQ \
	--out $OUT \
	--recode --recode-INFO-all \
	--stdout | bgzip -c > $OUT".vcf.gz"

	tabix $OUT".vcf.gz"
}

## Modify paths below

OUT_DIR=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/4_vcftools_filtering/1_snps_filtering
VCF=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/3_nocentromere/072026_VNI_x1758_snps_HardFiltered_noCent.vcf.gz

## Modify filename and parameters for filtering
## The function is set to take minor allele count instead of minor allele frequency. 
FN="072126_VNI_x1758_snps"
alleles=2
mindp=5
maxmiss=0.9
minmaf=0
GQ=30

## Run function
vcftools_filtering $VCF $FN $OUT_DIR $alleles $mindp $maxmiss $minmaf $GQ