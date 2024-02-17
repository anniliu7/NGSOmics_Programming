# Reference: https://subread.sourceforge.net/SubreadUsersGuide.pdf
#! /bin/bash -l

#SBATCH --partition=panda
#SBATCH --nodes=1  
#SBATCH --ntasks=1 
#SBATCH --job-name=feature_count
#SBATCH --time=00:05:00 # HH/MM/SS
#SBATCH --mem=32G

# mamba activate rnaseq_env
conda activate rnaseq_env

echo "Starting at:" `date` > featureCounts_metainfo.txt
featureCounts -v 2>> featureCounts_metainfo.txt

# Summarize paired-end reads and count fragments 
featureCounts -T 20 \
-p --countReadPairs
-t exon \
-g gene_id \ # or gene_name; instruct featureCounts to use the gene_id/gene_name attribute from the GTF file to define features
-a hs_ch38_annotation.gtf \
-o featureCounts_output.txt \
Human_Infectious_Disease_Aligned.sortedByCoord.out.bam # or $HOME/data/BAM/*.sortedByCoord.out.bam

# T: use 20 threads
# head $HOME/data/reference_genome/hg38.knownGene.gtf -n 6 | tail -n 1
