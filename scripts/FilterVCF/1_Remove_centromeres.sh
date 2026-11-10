#!/bin/bash

## Scripts to remove centromeres
## The centromere file VNI_cent_match.tsv contains the coordinates of the centromeres in the VNI reference genome
## This was obtained after running blast for the centeomere sequences range from the rnai paper (2018) against the VNI reference genome (H99) used for the reads alignemnt
## doi: 10.1073/pnas.1713725115.

source /home/efigueroa/programs/miniforge3/etc/profile.d/mamba.sh
mamba activate popgen

centromeres=/FastData/efigueroa/fastq_processing/reference/VNI_cent_match.tsv
VCF=/FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/2_HardFiltration/071526_VNI_x1758_snps_HardFiltered.vcf.gz
OUT="072026_VNI_x1758_snps_HardFiltered_noCent.vcf.gz"

cd /FastData/efigueroa/fastq_processing/mapping_gatk_variants/diploid_vcfs/VNI_x1758/3_nocentromere

bcftools view -T ^$centromeres $VCF -Oz -o $OUT
tabix -p vcf $OUT