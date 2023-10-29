# https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf
# The workflow of STAR: 1) build a reference genome index; 2) map reads to the reference genome
# STAR’s default parameters are optimized for mammalian genomes (e.g., human genome)

# Download latest STAR source
wget https://github.com/alexdobin/STAR/archive/2.7.11a.tar.gz
tar -xzf 2.7.11a.tar.gz
cd STAR-2.7.11a

# Compile under Mac OS X
brew install gcc
cd source
make STARforMacStatic CXX=/usr/local/Cellar/gcc/8.2.0/bin/g++-8
cp STAR /usr/local/bin

# Build a reference genome index
mkdir -p bulk_RNAseq/hg38_chr1_index

STAR --runThreadN 20 \
--runMode genomeGenerate \ 
--genomeDir bulk_RNAseq/hg38_chr1_index \
--genomeFastaFiles bulk_RNAseq/reference_data/homo_sapiens.GRCh38.dna.chromosome.1.fa \
--sjdbGTFfile bulk_RNAseq/reference_data/homo_sapiens.GRCh38.92.gtf \
--sjdbOverhang 99

# genomeDir: provide the path to store the genome indices
# genomeFastaFiles: provide the path to one or more reference genomes in FASTA format
# sjdbGTFfile: provide the path to the annotations of the reference genome in GTF format
# sjdbOverhang: this is the length of the genomic sequence around the annotated junction to be used in constructing the splice junctions database. Ideally, this length should equal to the max(ReadLength)-1, where ReadLength is the length of the reads. e.g., for Illumina 2x100b paired-end reads, the ideal value is 100-1=99. Often, 100 works quite well.

# Map reads to the reference genome
STAR --genomeDir bulk_RNAseq/hg38_chr1_index \
--runThreadN 20 \
--readFilesIn bulk_RNAseq/raw_data/s1read1.fq.gz,s2read1.fq.gz s1read2.fq.gz,s2read2.fq.gz \
--outFileNamePrefix bulk_RNAseq/results/STAR/Human_Infectious_Disease_ \
--outSAMtype BAM SortedByCoordinate \
--outSAMunmapped Within \
--outSAMattributes Standard 

# STAR has the capability to generate alignments in the binary BAM format directly, eliminating the need to convert SAM files to BAM, which can save our time. Additionally, STAR can sort BAM files by coordinates, a necessary step for numerous downstream applications.