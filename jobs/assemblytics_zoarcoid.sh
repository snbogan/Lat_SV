#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=assemblytics_zoarcoid
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=7-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=assemblytics_zoarcoid_%A_%a.out
#SBATCH --error=assemblytics_zoarcoid_%A_%a.err
#SBATCH --array=1-171

# Load necessary modules
module load miniconda3
conda activate mummer4

# Define the directory containing the delta files
DELTA_DIR="/hb/home/snbogan/Lat_SV/genomes/zoarcoidei/mummer_output"
OUTPUT_DIR="/hb/home/snbogan/Lat_SV/assemblytics"

# Get the delta file for this array task
DELTA_FILE=$(ls $DELTA_DIR/*.delta | sed -n "${SLURM_ARRAY_TASK_ID}p")

# Define the output prefix based on the input delta file
OUTPUT_PREFIX="${OUTPUT_DIR}/$(basename $DELTA_FILE .delta)"

# Define the parameters
UNIQUE_ANCHOR_LENGTH=1000
MIN_VARIANT_SIZE=50
MAX_VARIANT_SIZE=10000000  # 10 MB

# Run Assemblytics
assemblytics $DELTA_FILE $OUTPUT_PREFIX $UNIQUE_ANCHOR_LENGTH $MIN_VARIANT_SIZE $MAX_VARIANT_SIZE
