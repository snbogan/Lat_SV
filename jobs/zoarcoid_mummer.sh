#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=mummer_zoarcoid
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=7-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=mummer_zoarcoid_%A_%a.out
#SBATCH --error=mummer_zoarcoid_%A_%a.err
#SBATCH --array=1-171

# Load necessary modules
module load miniconda3
conda activate mummer4

# Set paths
REFERENCE_LIST="/hb/home/snbogan/Lat_SV/genomes/zoarcoidei/zoarcoid_mummer_list.txt"  # File with paths to the 19 reference FASTAs
OUTPUT_DIR="/hb/home/snbogan/Lat_SV/genomes/zoarcoidei/mummer_output"

# Calculate the pairwise combinations of genomes
total_genomes=$(wc -l < "${REFERENCE_LIST}")
pair_index=0

for i in $(seq 1 $total_genomes); do
    for j in $(seq $((i+1)) $total_genomes); do
        pair_index=$((pair_index + 1))
        if [[ $pair_index -eq ${SLURM_ARRAY_TASK_ID} ]]; then
            REF_GENOME=$(sed -n "${i}p" "${REFERENCE_LIST}")
            QUERY_GENOME=$(sed -n "${j}p" "${REFERENCE_LIST}")
            REF_NAME=$(basename "${REF_GENOME}" .fasta)
            QUERY_NAME=$(basename "${QUERY_GENOME}" .fasta)

            # Create a unique prefix for this alignment
            PREFIX="${OUTPUT_DIR}/${REF_NAME}_vs_${QUERY_NAME}"

            # Step 1: Align the genomes with 4 threads
            nucmer --threads=4 --prefix="${PREFIX}" "${REF_GENOME}" "${QUERY_GENOME}"

            # Step 2: Filter the alignments
            delta-filter -r -q "${PREFIX}.delta" > "${PREFIX}.filtered.delta"

            # Step 3: Generate coordinates for visualization
            show-coords -rcl "${PREFIX}.filtered.delta" > "${PREFIX}.filtered.coords"

            echo "Alignment and filtering for ${REF_NAME} vs ${QUERY_NAME} completed."
            exit 0
        fi
    done
done

