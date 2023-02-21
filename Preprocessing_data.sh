## Author: Simranjeet Kaur

## Seperate data for each chromosome 

for chr in {1..22}; do \
plink --bfile DupsRemoved.genotypes --chr $chr --make-bed --out chr_bed_files/merged_dupsremoved_chr${chr}; \
done

## Convert to vcf files

for chr in {1..22}; do \
plink --noweb --bfile chr_bed_files/merged_dupsremoved_chr${chr} --recode vcf --keep-allele-order --out final_vcf_files/DupsRemoved_chr${chr};\
done

## bgzip all vcf files

for chr in {1..22}; do \
sed 's/GSA-//g' DupsRemoved_chr"${chr}".vcf |bgzip >DupsRemoved_chr"${chr}".vcf.gz;\
done

##Make index of vcf files using bcftools

for chr in {1..22}; do \
bcftools index DupsRemoved_chr"${chr}".vcf.gz;
done

## Check the strand issue 

## Download conform-gt tool from https://faculty.washington.edu/browning/conform-gt.html to check and fix any strand inconsistencies
# This is described in strand_issue.sh

