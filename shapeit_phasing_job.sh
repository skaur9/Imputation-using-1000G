## Prephasing each CHR using SHAPEIT . The following example is for CHR1, replace the CHR number to do Prephasing on each CHR

#!/bin/bash
#PBS -W group_list=#### -A #### 
#PBS -N prephasing_shapeit
#PBS -o $PBS_JOBID.out
#PBS -e $PBS_JOBID.err 
#PBS -l nodes=1:ppn=10
#PBS -l walltime=99:00:00

module load shapeit/2.r837
cd /home/projects/####/data/1000_genome/ 

CHR=1
 
# directories
ROOT_DIR=./
DATA_DIR=${ROOT_DIR}data_files/
RESULTS_DIR=${ROOT_DIR}results/
 
# executable
#SHAPEIT_EXEC=${ROOT_DIR}shapeit
 
# parameters
THREAT=4
EFFECTIVESIZE=11418
 
# reference data files
GENMAP_FILE=${DATA_DIR}genetic_map_chr${CHR}_combined_b37.txt
 
# GWAS data files in PLINK BED format
GWASDATA_BED=${DATA_DIR}gwas_data_chr${CHR}.bed
GWASDATA_BIM=${DATA_DIR}gwas_data_chr${CHR}.bim
GWASDATA_FAM=${DATA_DIR}gwas_data_chr${CHR}.fam

# main output file
OUTPUT_HAPS=${RESULTS_DIR}chr${CHR}.haps
OUTPUT_SAMPLE=${RESULTS_DIR}chr${CHR}.sample
OUTPUT_LOG=${RESULTS_DIR}chr${CHR}.log
 
## phase GWAS genotypes
shapeit \
--input-bed $GWASDATA_BED $GWASDATA_BIM $GWASDATA_FAM \
--input-map $GENMAP_FILE \
--thread $THREAT \
--effective-size $EFFECTIVESIZE \
--output-max $OUTPUT_HAPS $OUTPUT_SAMPLE \
--output-log $OUTPUT_LOG
