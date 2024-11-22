#!/bin/bash
#SBATCH --account=pi-jkoc
#SBATCH --partition=lab-colibri
#SBATCH --qos=pi-jkoc
#SBATCH --job-name=Actinopt_genome_download
#SBATCH --time=7-00:00:00
#SBATCH --mail-user=snbogan@ucsc.edu
#SBATCH --mail-type=ALL
#SBATCH --output=Actinopt_genome_download.out
#SBATCH --error=Actinopt_genome_download.err
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=48GB

# Load ncbi data toolkit
module load miniconda3

conda activate ncbi-datasets-cli

# Set wd
cd /hb/home/snbogan/Lat_SV/genomes

# Download chromosome-scale genome assemblies

datasets download genome taxon "Actinopterygii" \
  --assembly-level chromosome,complete \
  --filename actinopterygii_chrom_genomes.zip

unzip actinopterygii_chrom_genomes.zip

