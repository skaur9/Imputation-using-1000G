#!/bin/bash
#PBS -W group_list=***** -A *******
#PBS -N HRC_2024
#PBS -o $PBS_JOBNAME.$PBS_JOBID.out
#PBS -e $PBS_JOBNAME.$PBS_JOBID.err 
#PBS -l nodes=1:ppn=23,mem=100gb
#PBS -l walltime=999:00:00

module load htslib/1.8
module load perl/5.20.2
module load vcftools/0.1.16
module load bcftools/1.9
module load annovar/2018apr16
module load plink2/1.90beta5.4
module load samtools/1.9


######################
## 1. Unzip files
####################

group=$1
password=$2
cd ${group}

unzipResult () {

		local i=$1
		if [ -f chr_${i}.zip ]; then
			echo -e "UNZIP CHR${i}"
			7za e -p"${password}" chr_${i}.zip
			wait
			#rm -f chr_${i}.zip
		fi

}


for chr in {1..22}; do
	unzipResult "${chr}"
done
wait

echo -e "FINISHED UNZIPPING ${group}"


######################
## 2. Concatenate info files
######################

getCombinedInfo () {
	local group=$1
  echo ${group}
	zcat ${results}/${group}/chr1.info.gz | awk 'NR==1' > ${results}/${group}/chrALL.info
	for i in {1..22}; do
    echo "chr${i}"
		zcat ${results}/${group}/chr${i}.info.gz | awk 'NR>1' >> ${results}/${group}/chrALL.info
	done
  awk '$8=="Genotyped"' ${results}/${group}/chrALL.info > ${results}/${group}/typed_variants.txt
  echo " "
}

getCombinedInfo dk3a_12

######################
## 3. Filter for MAF and R2 and concatenate vcf files
######################

#Filter MAF and R2
for i in {1..22}; do
bcftools view -i 'R2>0.6 & MAF>.05' -Oz chr${i}.dose.vcf.gz >filtered_data/chr${i}.filtered.vcf.gz
done

#Make index of vcf files using bcftools
for chr in {1..22}; do \
bcftools index chr"${chr}".filtered.vcf.gz;
done

#### Merge all vcf files 
bcftools concat chr{1..22}.filtered.vcf.gz -Oz -o HRC_2024_merged.vcf.gz

#Get statistics
bcftools stats HRC_2024_merged.vcf.gz >HRC_2024_merged.vcf.stats


######################
## 4. Update rs ids to b150 (dbSNP 150)
######################

#### get dbSNP 150 file ####
#	cd ${humandb}
	wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/VCF/00-All.vcf.gz
  tabix -p vcf 00-All.vcf.gz

bcftools index HRC_2024_merged.vcf.gz

bcftools annotate -a $humandb/00-All.vcf.gz -c ID -o  HRC_2024_annotated_dbsnp150.vcf.gz HRC_2024_merged.vcf.gz

######################
## 5.  Generate Plink Files
######################

## Convert Vcf to bed

# skipping all variants with 2+ alternate alleles: and convert to plink format

plink --vcf HRC_2024_annotated_dbsnp150.vcf.gz \
   --keep-allele-order \
    -vcf-idspace-to _ \
    --double-id \
    --allow-extra-chr 0 \
    --split-x b38 no-fail \
    --make-bed \
    --snps-only just-acgt \
    --out HRC_2024_annotated_dbsnp150


