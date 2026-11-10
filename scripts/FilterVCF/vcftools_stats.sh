#!/bin/bash

source /home/efigueroa/programs/miniforge3/etc/profile.d/mamba.sh
mamba activate popgen

vcftools_stats(){
	local VCF=$1
	local VCF_FN=$2
	local OUT_DIR=$3
	## Remover ## depending on needed stat

	## Mean missing data per site
	vcftools --gzvcf $VCF --missing-site --out $OUT_DIR/$VCF_FN"_miss_per_site"
	## Mean missing data per sample
	vcftools --gzvcf $VCF --missing-indv --out $OUT_DIR/$VCF_FN"_miss_per_sample"
	## Allele frequency
	vcftools --gzvcf $VCF --freq2 --out $OUT_DIR/$VCF_FN"_freq" --max-alleles 2
	## Mean depth per sample
	vcftools --gzvcf $VCF --depth --out $OUT_DIR/$VCF_FN"_depth"
	## Mean depth per site
	#vcftools --gzvcf $VCF --site-mean-depth --out $OUT_DIR/$VCF_FN"_dp_per_site"
	## Mean quality per site. This can remain as comment if quality filter was done
	#vcftools --gzvcf $VCF --site-quality --out $OUT_DIR/$VCF_FN"_qual_per_site"
	## Heterozygosity. Deactivate after Het masking
	#vcftools --gzvcf $VCF --max-alleles 2 --het --out $OUT_DIR/$VCF_FN"_heterozygosity"
}

## Vcftools stats filtered VCF

OUT_DIR1=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/6_final_VCFs/maf0/maskedHet/0_stats
VCF1=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/6_final_VCFs/maf0/maskedHet/073126_VNI_x1724_snps_maskedHet_maf0_filt_ann_remSamples.vcf.gz
FN1="08282026_VNI_x1724_snps_maskedHet_maf0"

vcftools_stats $VCF1 $FN1 $OUT_DIR1
