## Imputing each CHR using Impute2 . The following example is for CHR1, replace the CHR number to do Imputation on each CHR

#!/bin/bash
#PBS -W group_list=#### -A #### 
#PBS -N Imputation_Impute2
#PBS -o $PBS_JOBID.out
#PBS -e $PBS_JOBID.err 
#PBS -l nodes=1:ppn=10
#PBS -l walltime=99:00:00


module load impute/2.3.2
cd /home/projects/####/data/1000_genome/ 

CHR=$1
CHUNK_START=`printf "%.0f" $2`
CHUNK_END=`printf "%.0f" $3`
 
# directories
ROOT_DIR=./
DATA_DIR=${ROOT_DIR}data_files/
RESULTS_DIR=${ROOT_DIR}results/
 
# executable (must be IMPUTE version 2.2.0 or later)
IMPUTE2_EXEC=${ROOT_DIR}impute2
 
# parameters
NE=20000
 
## MODIFY THE FOLLOWING THREE LINES TO ACCOMODATE OTHER PANELS
# reference data files
GENMAP_FILE=${DATA_DIR}genetic_map_chr${CHR}_combined_b37.txt
HAPS_FILE=${DATA_DIR}ALL_1000G_phase1integrated_v3_chr${CHR}_impute.hap.gz
LEGEND_FILE=${DATA_DIR}ALL_1000G_phase1integrated_v3_chr${CHR}_impute.legend.gz
 
## THESE HAPLOTYPES WOULD BE GENERATED BY THE PREVIOUS SCRIPT
## SELECT ONE FROM METHOD-A AND METHOD-B BELOW
# METHOD-A: haplotypes from IMPUTE2 phasing run
GWAS_HAPS_FILE=${RESULTS_DIR}gwas_data_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.phasing.impute2_haps

# METHOD-B: haplotypes from SHAPEIT phasing run
GWAS_HAPS_FILE=${RESULTS_DIR}chr${CHR}.haps
 
# main output file
OUTPUT_FILE=${RESULTS_DIR}gwas_data_chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.impute2
 
## impute genotypes from GWAS haplotypes
$IMPUTE2_EXEC \
   -use_prephased_g \
   -m $GENMAP_FILE \
   -known_haps_g $GWAS_HAPS_FILE \
   -h $HAPS_FILE \
   -l $LEGEND_FILE \
   -Ne $NE \
   -int $CHUNK_START $CHUNK_END \
   -o $OUTPUT_FILE \
   -allow_large_regions \
   -seed 367946
