## Author: Simranjeet Kaur


#!/bin/bash
#PBS -W group_list=#### -A ####
#PBS -N strand_issue_Conform-gt
#PBS -o $PBS_JOBNAME.out
#PBS -e $PBS_JOBNAME.err 
#PBS -l nodes=1:ppn=10
#PBS -l walltime=99:00:00


cd /home/projects/####/data/1000_genome

for chr in {1..22}; do

java -jar conform-gt.24May16.cee.jar gt=Dupsremoved_chr"${chr}".vcf.gz chrom=$chr ref=/home/projects/####/data/1000_genome/1000GP_Phase3/beagle_files/chr"${chr}".1kg.phase3.v5a.vcf.gz out=mod_chr"${chr}"  excludesamples=/home/projects/####/data/1000_genome/1000GP_Phase3/beagle_files/non.eur.excl.txt;\
done



## Issues with chr2.1kg.phase3.v5a.vcf.gz

#Identified the following Non-unique marker IDs in chr2.1kg.phase3.v5a.vcf.gz

#2	11656437	.;rs531258135	GGTGTGTGTGTGTGT	GGTGTGTGTGTCTGT,G
#2	18004148	.;rs541466601	AGAGCCCA	AGAGCCCG,A
#2	33172927	.;rs554173463	GC	GA,G
#2	40484170	.;rs537996337	AAATAAATA	AAATAAATG,A
#2	44234879	rs550419970;.;rs533534296	ATAAA	ATAAATAAA,ATAAG,A
#2	45515468	.;rs544467622	CTTTTGT	CTTTTAT,C
#2	47982412	.;rs536566627	GG	GC,G
#2	74559847	.;rs564494041	TGT	TGC,T
#2	77195037	.;rs548983836	TTAC	TCAC,T
#2	84495638	rs573607330;.;rs569169043	AATAA	AATAAATAA,AATAT,A
#2	109192726	.;rs539410502	GTTTTGTTTTG	GTTTTGTTTTC,G
#2	179073443	.;rs538697958	TTTTCC	TTTGCC,T
#2	206417755	rs574286642;.;rs576039119	AGAA	AGAAGAA,AGAG,A
#2	221264917	.;esv3594380	TTATCATTTTTATATATTATTAGTATAAATTTGCTATAATTTTGCTTATTTTTTTGCATCTGTATTCATTAA	TAATATCATTTTTATATATTATTAGTATAAATTTGCTATAATTTTGCTTATTTTTTTGCATCTGTATTCATTAA,T

#Updated file after removing the non-unique marker IDs and saved as chr2.1kg.phase3.v5a_updated7.vcf.gz 

# Re-run the conform-gt tool with chr2.1kg.phase3.v5a_updated7.vcf.gz 

java -jar conform-gt.24May16.cee.jar gt=Dupsremoved_chr2.vcf.gz chrom=$chr ref=/home/projects/####/data/1000_genome/1000GP_Phase3/beagle_files/chr2.1kg.phase3.v5a_updated7.vcf.gz out=mod_chr"${chr}"  excludesamples=/home/projects/####/data/1000_genome/1000GP_Phase3/beagle_files/non.eur.excl.txt;\


##Make index of vcf files using bcftools

for chr in {1..22}; do \
bcftools index mod_chr"${chr}".vcf.gz;
done


##Merge all vcf files 

bcftools merge *vcf.gz --force-samples -Oz -o merged.vcf.gz
