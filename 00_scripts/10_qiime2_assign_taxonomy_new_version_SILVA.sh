#!/usr/bin/env bash


###############################################################
### For 16S
###############################################################


WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_16S
OUTPUT=/home/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_16S/visual

DATABASE=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files
TMPDIR=/scratch_vol0

#QIIME="singularity exec --cleanenv -B /scratch_vol0:/scratch_vol0 /scratch_vol0/fungi/qiime2_images/qiime2-2024.5.sif qiime"


# Aim: classify reads by taxon using a fitted classifier

# https://docs.qiime2.org/2019.10/tutorials/moving-pictures/
# In this step, you will take the denoised sequences from step 5 (rep-seqs.qza) and assign taxonomy to each sequence (phylum -> class -> …genus -> ). 
# This step requires a trained classifer. You have the choice of either training your own classifier using the q2-feature-classifier or downloading a pretrained classifier.

# https://docs.qiime2.org/2019.10/tutorials/feature-classifier/


# Aim: Import data to create a new QIIME 2 Artifact
# https://gitlab.com/IAC_SolVeg/CNRT_BIOINDIC/-/blob/master/snk/12_qiime2_taxonomy


###############################################################
### For Bacteria
###############################################################

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10
#conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

#export PYTHONPATH="${PYTHONPATH}:/scratch_vol0/fungi/.local/lib/python3.9/site-packages/"
#echo $PYTHONPATH

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p taxonomy/16S
mkdir -p export/taxonomy/16S

#singularity exec --cleanenv --env TMPDIR=/scratch_vol0/fungi

####### OK ! Je # pour gagner du temps ici
###### Code from: https://forum.qiime2.org/t/processing-filtering-and-evaluating-the-silva-database-and-other-reference-sequence-data-with-rescript/15494
######qiime rescript get-silva-data \
######    --p-version '138.2' \
######    --p-target 'SSURef_NR99' \
######    --o-silva-sequences silva-138.2-ssu-nr99-rna-seqs.qza \
######    --o-silva-taxonomy silva-138.2-ssu-nr99-tax.qza

####### If you'd like to be able to jump to steps that only take FeatureData[Sequence] as input you can convert your data to FeatureData[Sequence] like so:
######qiime rescript reverse-transcribe \
######    --i-rna-sequences silva-138.2-ssu-nr99-rna-seqs.qza \
######    --o-dna-sequences silva-138.2-ssu-nr99-seqs.qza
######
####### “Culling” low-quality sequences with cull-seqs
####### Here we’ll remove sequences that contain 5 or more ambiguous bases (IUPAC compliant ambiguity bases) and any homopolymers that are 8 or more bases in length. These are the default parameters.
######qiime rescript cull-seqs \
######    --i-sequences silva-138.2-ssu-nr99-seqs.qza \
######    --o-clean-sequences silva-138.2-ssu-nr99-seqs-cleaned.qza
######
####### Filtering sequences by length and taxonomy
######qiime rescript filter-seqs-length-by-taxon \
######    --i-sequences silva-138.2-ssu-nr99-seqs-cleaned.qza \
######    --i-taxonomy silva-138.2-ssu-nr99-tax.qza \
######    --p-labels Archaea Bacteria Eukaryota \
######    --p-min-lens 900 1200 1400 \
######    --o-filtered-seqs silva-138.2-ssu-nr99-seqs-filt.qza \
######    --o-discarded-seqs silva-138.2-ssu-nr99-seqs-discard.qza 
######
#######Dereplicating in uniq mode
######qiime rescript dereplicate \
######    --i-sequences silva-138.2-ssu-nr99-seqs-filt.qza  \
######    --i-taxa silva-138.2-ssu-nr99-tax.qza \
######    --p-mode 'uniq' \
######    --o-dereplicated-sequences silva-138.2-ssu-nr99-seqs-derep-uniq.qza \
######    --o-dereplicated-taxa silva-138.2-ssu-nr99-tax-derep-uniq.qza
######
######
######qiime feature-classifier fit-classifier-naive-bayes \
######  --i-reference-reads  silva-138.2-ssu-nr99-seqs-derep-uniq.qza \
######  --i-reference-taxonomy silva-138.2-ssu-nr99-tax-derep-uniq.qza \
######  --o-classifier silva-138.2-ssu-nr99-classifier.qza    
######
######
####### Here only for V4 --> forward: 'GTGCCAGCMGCCGCGGTAA'  # 515f & reverse: 'GGACTACHVGGGTWTCTAAT' # 806r
#######qiime feature-classifier extract-reads --i-sequences taxonomy/DataSeq.qza \
#######        --p-f-primer 'GTGCCAGCMGCCGCGGTAA' \
#######        --p-r-primer 'TCCTCCGCTTATTGATATGC' \
#######        --o-reads taxonomy/RefSeq.qza 
######
####### Here for V1V2V3V4 --> 27F 'AGAGTTTGATCCTGGCTCAG' & reverse: 'GGACTACHVGGGTWTCTAAT' # 806r
#######qiime feature-classifier extract-reads --i-sequences taxonomy/DataSeq.qza \
#######        --p-f-primer 'AGAGTTTGATCCTGGCTCAG' \
#######        --p-r-primer 'TCCTCCGCTTATTGATATGC' \
#######        --o-reads taxonomy/RefSeq.qza         
######
######
####### If necessary :
####### https://forum.qiime2.org/t/available-pre-trained-classifier-of-v3-v4-341f-805r-region-with-gg-99/3275
####### Available: Pre-trained classifier of V3-V4 (341F, 805R) region with gg_99
######
####### 16S : V3/V4 : V3V4 (amplified with primers 341F–805R)
#########qiime feature-classifier extract-reads --i-sequences taxonomy/DataSeq.qza \
#########        --p-f-primer 'CCTACGGGNGGCWGCAG' \
#########        --p-r-primer 'GACTACHVGGGTATCTAATCC' \
#########        --o-reads taxonomy/RefSeq.qza 
#########
######
####### According ADNiD: Caporaso et al. (1), 515f Original and 806r Original
######
####### From Clarisse and from bioinformatics <bioinformatics@microsynth.ch>
####### The sequences for the V34 primers were:
####### 341F    CCTACGGGNGGCWGCAG       805R    GACTACHVGGGTATCTAATCC
#######qiime feature-classifier extract-reads --i-sequences taxonomy/16S/DataSeq.qza \
#######        --p-f-primer 'CCTACGGGNGGCWGCAG' \
#######        --p-r-primer 'GACTACHVGGGTATCTAATCC' \
#######        --o-reads taxonomy/16S/RefSeq.qza 
######
######
####### Original from tuto:
#######    --p-f-primer GTGYCAGCMGCCGCGGTAA \
#######    --p-r-primer GGACTACNVGGGTWTCTAAT \
######
####### From Clarisse and from bioinformatics <bioinformatics@microsynth.ch>
####### The sequences for the V34 primers were:
####### 341F    CCTACGGGNGGCWGCAG       805R    GACTACHVGGGTATCTAATCC
######
######qiime feature-classifier extract-reads \
######    --i-sequences silva-138.2-ssu-nr99-seqs-derep-uniq.qza \
######    --p-f-primer CCTACGGGNGGCWGCAG \
######    --p-r-primer GACTACHVGGGTATCTAATCC \
######    --p-n-jobs 2 \
######    --p-read-orientation 'forward' \
######    --o-reads silva-138.2-ssu-nr99-seqs-341f-805r.qza
######
######qiime rescript dereplicate \
######    --i-sequences silva-138.2-ssu-nr99-seqs-341f-805r.qza \
######    --i-taxa silva-138.2-ssu-nr99-tax-derep-uniq.qza \
######    --p-mode 'uniq' \
######    --o-dereplicated-sequences silva-138.2-ssu-nr99-seqs-341f-805r-uniq.qza \
######    --o-dereplicated-taxa  silva-138.2-ssu-nr99-tax-341f-805r-derep-uniq.qza
######
####### Aim: Create a scikit-learn naive_bayes classifier for reads
#######qiime feature-classifier fit-classifier-naive-bayes \
#######  --i-reference-reads taxonomy/16S/RefSeq.qza \
#######  --i-reference-taxonomy taxonomy/16S/RefTaxo.qza \
#######  --o-classifier taxonomy/16S/Classifier.qza
######  
####### Aim: Create a scikit-learn naive_bayes classifier for reads
######qiime feature-classifier fit-classifier-naive-bayes \
######    --i-reference-reads silva-138.2-ssu-nr99-seqs-341f-805r-uniq.qza \
######    --i-reference-taxonomy silva-138.2-ssu-nr99-tax-341f-805r-derep-uniq.qza \
######    --o-classifier silva-138.2-ssu-nr99-341f-805r-classifier.qza
    
scp -r /scratch_vol0/fungi/dugong_microbiome/05_QIIME2/silva-138.2-ssu-nr99-341f-805r-classifier.qza taxonomy/16S/Classifier.qza

# Aim: Create a scikit-learn naive_bayes classifier for reads

qiime feature-classifier classify-sklearn \
   --i-classifier taxonomy/16S/Classifier.qza \
   --i-reads core/ConRepSeq.qza \
   --o-classification taxonomy/16S/taxonomy_reads-per-batch_ConRepSeq.qza
   
qiime feature-classifier classify-sklearn \
  --i-classifier taxonomy/16S/Classifier.qza \
  --i-reads core/RepSeq.qza \
  --o-classification taxonomy/16S/taxonomy_reads-per-batch_RepSeq.qza

qiime feature-classifier classify-sklearn \
  --i-classifier taxonomy/16S/Classifier.qza \
  --i-reads core/RarRepSeq.qza \
  --o-classification taxonomy/16S/taxonomy_reads-per-batch_RarRepSeq.qza

# Switch to https://chmi-sops.github.io/mydoc_qiime2.html#step-9-assign-taxonomy
# --p-reads-per-batch 0 (default)

qiime metadata tabulate \
  --m-input-file taxonomy/16S/taxonomy_reads-per-batch_RarRepSeq.qza \
  --o-visualization taxonomy/16S/taxonomy_reads-per-batch_RarRepSeq.qzv

qiime metadata tabulate \
  --m-input-file taxonomy/16S/taxonomy_reads-per-batch_ConRepSeq.qza \
  --o-visualization taxonomy/16S/taxonomy_reads-per-batch_ConRepSeq.qzv
  
qiime metadata tabulate \
  --m-input-file taxonomy/16S/taxonomy_reads-per-batch_RepSeq.qza \
  --o-visualization taxonomy/16S/taxonomy_reads-per-batch_RepSeq.qzv  

# Now create a visualization of the classified sequences.
  
qiime taxa barplot \
  --i-table core/Table.qza \
  --i-taxonomy taxonomy/16S/taxonomy_reads-per-batch_RepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/16S/16Staxa-bar-plots_reads-per-batch_RepSeq.qzv

qiime taxa barplot \
  --i-table core/ConTable.qza \
  --i-taxonomy taxonomy/16S/taxonomy_reads-per-batch_ConRepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/16S/16Staxa-bar-plots_reads-per-batch_ConRepSeq.qzv
  
qiime taxa barplot \
  --i-table core/RarTable.qza \
  --i-taxonomy taxonomy/16S/taxonomy_reads-per-batch_RarRepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/16S/16Staxa-bar-plots_reads-per-batch_RarRepSeq.qzv  

qiime tools export --input-path taxonomy/16S/Classifier.qza --output-path export/taxonomy/16S/Classifier
qiime tools export --input-path taxonomy/16S/RefSeq.qza --output-path export/taxonomy/16S/RefSeq
qiime tools export --input-path taxonomy/16S/16SDataSeq.qza --output-path export/taxonomy/16S/16SDataSeq
qiime tools export --input-path taxonomy/16S/RefTaxo.qza --output-path export/taxonomy/16S/RefTaxo
  
qiime tools export --input-path taxonomy/16S/16Staxa-bar-plots_reads-per-batch_RarRepSeq.qzv --output-path export/taxonomy/16S/16Staxa-bar-plots_reads-per-batch_RarRepSeq
qiime tools export --input-path taxonomy/16S/16Staxa-bar-plots_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/16S/16Staxa-bar-plots_reads-per-batch_ConRepSeq
qiime tools export --input-path taxonomy/16S/16Staxa-bar-plots_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/16S/16Staxa-bar-plots_reads-per-batch_RepSeq

qiime tools export --input-path taxonomy/16S/taxonomy_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/16S/taxonomy_reads-per-batch_RepSeq_visual
qiime tools export --input-path taxonomy/16S/taxonomy_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/16S/taxonomy_reads-per-batch_ConRepSeq_visual
qiime tools export --input-path taxonomy/16S/taxonomy_reads-per-batch_RarRepSeq.qzv --output-path export/taxonomy/16S/taxonomy_reads-per-batch_RarRepSeq_visual

qiime tools export --input-path taxonomy/16S/taxonomy_reads-per-batch_RepSeq.qza --output-path export/taxonomy/16S/taxonomy_reads-per-batch_RepSeq
qiime tools export --input-path taxonomy/16S/taxonomy_reads-per-batch_ConRepSeq.qza --output-path export/taxonomy/16S/taxonomy_reads-per-batch_ConRepSeq
qiime tools export --input-path taxonomy/16S/taxonomy_reads-per-batch_RarRepSeq.qza --output-path export/taxonomy/16S/taxonomy_reads-per-batch_RarRepSeq

###############################################################
### For 18S
###############################################################

echo ###############################################################
echo 18S
echo ###############################################################

WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_18S
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_18S/visual

DATABASE=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files
TMPDIR=/scratch_vol0

# Aim: classify reads by taxon using a fitted classifier

# https://docs.qiime2.org/2019.10/tutorials/moving-pictures/
# In this step, you will take the denoised sequences from step 5 (rep-seqs.qza) and assign taxonomy to each sequence (phylum -> class -> …genus -> ). 
# This step requires a trained classifer. You have the choice of either training your own classifier using the q2-feature-classifier or downloading a pretrained classifier.

# https://docs.qiime2.org/2019.10/tutorials/feature-classifier/


# Aim: Import data to create a new QIIME 2 Artifact
# https://gitlab.com/IAC_SolVeg/CNRT_BIOINDIC/-/blob/master/snk/12_qiime2_taxonomy


cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate qiime2-2021.4

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p taxonomy
mkdir -p export/taxonomy

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

###### All this step was for "old" database, now we uysed new ones 
######
######
######
######qiime tools import --type 'FeatureData[Taxonomy]' \
######  --input-format HeaderlessTSVTaxonomyFormat \
######  --input-path /Users/pierre-louisstenger/Documents/PostDoc_02_MetaBarcoding_IAC/02_Data/07_BioIndic_La_Reunion_Island_seawater_four_month_SED/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/silva_nr99_v138_wSpecies_train_set.fa \
######  --output-path taxonomy/RefTaxo.qza
######
######qiime tools import --type 'FeatureData[Sequence]' \
######  --input-path /Users/pierre-louisstenger/Documents/PostDoc_02_MetaBarcoding_IAC/02_Data/07_BioIndic_La_Reunion_Island_seawater_four_month_SED/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/silva_nr99_v138_wSpecies_train_set.fa \
######  --output-path taxonomy/DataSeq.qza
######
######   
####### Aim: Extract sequencing-like reads from a reference database.
####### Warning: For v4 only !!! Not for its2 !!! 
######
####### The --p-trunc-len parameter should only be used to trim reference sequences,
####### if query sequences are trimmed to this same length or shorter.
###### 
####### Paired sequences that successfully join will typically be variable in length.
####### Single reads not truncated at a specific length may also be variable in length.
######
####### For classification of paired-end reads and untrimmed single-end reads,
####### we recommend training a classifier on sequences that have been extracted
####### at the appropriate primer sites, but are not trimmed !!!
####### -----
####### The primer sequences used for extracting reads should be the actual DNA-binding
####### (i.e., biological) sequence contained within a primer construct.
######
####### It should NOT contain any non-biological, non-binding sequence,
####### e.g., adapter, linker, or barcode sequences.
######
####### If you aren't sure what section of your primer sequences are actual DNA-binding
####### you should consult whoever constructed your sequencing library, your sequencing
####### center, or the original source literature on these primers.
######
####### If your primer sequences are > 30 nt long, they most likely contain some
####### non-biological sequence !
######
######qiime feature-classifier extract-reads --i-sequences taxonomy/DataSeq.qza \
######        --p-f-primer 'GTGCCAGCMGCCGCGGTAA' \
######        --p-r-primer 'TCCTCCGCTTATTGATATGC' \
######        --o-reads taxonomy/RefSeq.qza 
######        
######        #--p-trunc-len {params.length} \
######
####### Aim: Create a scikit-learn naive_bayes classifier for reads
######
######qiime feature-classifier fit-classifier-naive-bayes \
######  --i-reference-reads taxonomy/RefSeq.qza \
######  --i-reference-taxonomy taxonomy/RefTaxo.qza \
######  --o-classifier taxonomy/Classifier.qza

# With new database :

# See here for only V4 : https://www.dropbox.com/sh/nz7c5asn6b3hr1j/AADMAR-YZOBkpUQJLumZ9w3wa/ver_0.02?dl=0&subfolder_nav_tracking=1
# See here for all 16S : https://www.dropbox.com/sh/ibpy9j0clw8dzwm/AAAIVuYnqUzAOxlg2fijePQna/ver_0.02?dl=0&subfolder_nav_tracking=1

# See this thread https://forum.qiime2.org/t/silva-138-classifiers/13131 (found because of this thread : https://forum.qiime2.org/t/silva-138-for-qiime2/12957/4)

#cp $DATABASE/SILVA-138-SSURef-full-length-classifier.qza taxonomy/Classifier.qza
scp /home/fungi/Mayotte_microorganism_colonisation/98_database_files/SILVA-138-SSURef-Full-Seqs.qza  /scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_18S/taxonomy/DataSeq.qza
scp /home/fungi/Mayotte_microorganism_colonisation/98_database_files/Silva-v138-full-length-seq-taxonomy.qza /scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_18S/taxonomy/RefTaxo.qza

# Script Nolwenn
#R1_Primers = c("GTGCCAGCMGCCGCGGTAA","GTGYCAGCMGCCGCGGTAA")
#R2_Primers = c("GGACTACHVGGGTWTCTAAT","GGACTACNVGGGTWTCTAAT")

# Here only for V4 --> forward: 'GTGCCAGCMGCCGCGGTAA'  # 515f & reverse: 'GGACTACHVGGGTWTCTAAT' # 806r
#qiime feature-classifier extract-reads --i-sequences taxonomy/DataSeq.qza \
#        --p-f-primer 'GTGCCAGCMGCCGCGGTAA' \
#        --p-r-primer 'TCCTCCGCTTATTGATATGC' \
#        --o-reads taxonomy/RefSeq.qza 

# Here for V1V2V3V4 --> 27F 'AGAGTTTGATCCTGGCTCAG' & reverse: 'GGACTACHVGGGTWTCTAAT' # 806r
#qiime feature-classifier extract-reads --i-sequences taxonomy/DataSeq.qza \
#        --p-f-primer 'AGAGTTTGATCCTGGCTCAG' \
#        --p-r-primer 'TCCTCCGCTTATTGATATGC' \
#        --o-reads taxonomy/RefSeq.qza         



# 18S : V3/V4 : V3V4 (amplified with primers 515F-951R)
# Both 515 and 951 from https://pdf.sciencedirectassets.com/273234/1-s2.0-S1434461020X0006X/1-s2.0-S1434461020300754/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEC4aCXVzLWVhc3QtMSJGMEQCIHxzwEReHyOiP%2F3lD%2Fd8gFMQKz8KtVVz%2BCZ%2FZnJGSmO3AiBwq%2BcYWsea%2FLrut4XbW%2FeOCUmgRVBAycZr8fParQyiDCrSBAhGEAQaDDA1OTAwMzU0Njg2NSIMhhOZpx5yILl2f5ytKq8EF2HLVZZ8WSnjg0TEH%2F7KrJMFQ6TRL8aJOi81OVmRO%2FmU4BUzO2C%2F4S5KrLJaa%2F%2FQdFWJOHhuO1vIfM8pElD6UD86ylomuaLKPa4qrvNq1aHF63JCnA%2Fhe1XAzd6%2FnMx8U93p58c0KCz2iMTLvW4Jqx3FiMv3qYMC%2FD3sLyZbda1lCLN1OHLksndKD4VnTS5Xdntlop%2BDAV%2Fy8TnRadSEJSWC0GKxtMw%2F7SvQ2Zsh2nZsJyFk7sAbK9c72uWXTqM6lgVF2Ex7%2FZ1fe2AL09QLmQ5GDEY0zYpFvL22nWdWDfK7dZzbGPRukjz1frh9qQ9rVjlV8SZlYqvAYNNsXEgPqhEubP7lkzuoZaZUsidtw9km9YvUsOEvNsnEi5xxOBHnl9j%2BWmGdLksMW1ylHhq3A4XKvW1oIGe3PLPYBV1kahINQJAOb2UVF63MdR1nNqgdaryCBFJ8%2BLE4IeJIa5Qzi5GHz%2BZC09xVGYhnCENJvb463vcCOJaDvNX6jJ62%2FybZwVr9eFD1CRZvQfuEpLBOPOhtIIRbcyKvrddkS9yQ1Jw1Sx8hhVMKKtisi7mNxetCM2iLP3irHQJOzn2Fw3feQI%2FYcIGxzBuBGWA6pE6kKnqLBnwajgMYRysv3wtEBoCgvvwXXKOeOi4kvwc%2BxuihX%2FT9lydvYF%2FVkoMwc6BxbtIrxOiaNKV6y%2BFAXAWix%2BXG5jFzmoXsmmsDKVohjYGEnpW28ZK7aRkuGXG7tu2jZDDVhceVBjqqAfLZlpeLy5xQu3fEPajRGhAMpgI4era%2BnWQqaN54q%2BaJt8coXF%2BxNBMZsGZfi4iTlh8df3Fbv83IS7GWZobhHV2WqW%2BQa4vFrIMaTzE8nW2GxFTc4xY02trf72shqCZFDGW0EGpis9BiHZZXsjfHzqTIj3TlsugHtc7bcVavHywVq8dNhBR6pRmm4TTL1CraSYeEJSKm5dkNPVSvYfJ0i9bW3xKvuT6VzsVS&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220621T145134Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTYSEQQBGHO%2F20220621%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=994b4a56d54458cb691315bfbec0b31312c7782d862b70d492673e6beaa87a63&hash=60e7868d4ce24432665c5fd455a9125c7e18103702a1b31c5eab14e2dc9a70ca&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S1434461020300754&tid=spdf-3495c2e4-8343-4917-9ac2-fb7a60a25b78&sid=4c3ed3c03b2204413b9934b5789acf32651egxrqb&type=client&ua=4d5700025d5550525d5d07&rr=function 71ed902098c1053e {
# 515F : GTGCCAGCMGCCGCGG from https://resjournals.onlinelibrary.wiley.com/doi/full/10.1046/j.1365-3113.1999.00088.x?casa_token=SxTr_UxD3IoAAAAA%3AVO2wSeTZsdt1dlI222b-c9I19PORV3gcZvZlNy4_YzOfLLy6G1MoxSfO5yL3aYeGERE7LxPzY4iK50Wg
# 951 : Ek-NSR951 (TTGGYRAATGCTTTCGC) (Mangot et al., 2012) from https://www.frontiersin.org/articles/10.3389/fmicb.2016.00130/full
qiime feature-classifier extract-reads --i-sequences taxonomy/DataSeq.qza \
        --p-f-primer 'GTGCCAGCMGCCGCGG' \
        --p-r-primer 'TTGGYRAATGCTTTCGC' \
        --o-reads taxonomy/RefSeq.qza 

# Aim: Create a scikit-learn naive_bayes classifier for reads

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads taxonomy/RefSeq.qza \
  --i-reference-taxonomy taxonomy/RefTaxo.qza \
  --o-classifier taxonomy/Classifier.qza
  
# Aim: Create a scikit-learn naive_bayes classifier for reads

qiime feature-classifier classify-sklearn \
   --i-classifier taxonomy/Classifier.qza \
   --i-reads core/ConRepSeq.qza \
   --o-classification taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza
   
qiime feature-classifier classify-sklearn \
  --i-classifier taxonomy/Classifier.qza \
  --i-reads core/RepSeq.qza \
  --o-classification taxonomy/taxonomy_reads-per-batch_RepSeq.qza

qiime feature-classifier classify-sklearn \
  --i-classifier taxonomy/Classifier.qza \
  --i-reads core/RarRepSeq.qza \
  --o-classification taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza

# Switch to https://chmi-sops.github.io/mydoc_qiime2.html#step-9-assign-taxonomy
# --p-reads-per-batch 0 (default)

qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza \
  --o-visualization taxonomy/taxonomy_reads-per-batch_RarRepSeq.qzv

qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza \
  --o-visualization taxonomy/taxonomy_reads-per-batch_ConRepSeq.qzv
  
qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
  --o-visualization taxonomy/taxonomy_reads-per-batch_RepSeq.qzv  

# Now create a visualization of the classified sequences.
  
qiime taxa barplot \
  --i-table core/Table.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RepSeq.qzv

qiime taxa barplot \
  --i-table core/ConTable.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq.qzv
  
qiime taxa barplot \
  --i-table core/RarTable.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq.qzv  

# qiime tools export --input-path taxonomy/Classifier.qza --output-path export/taxonomy/Classifier
qiime tools export --input-path taxonomy/RefSeq.qza --output-path export/taxonomy/RefSeq
qiime tools export --input-path taxonomy/DataSeq.qza --output-path export/taxonomy/DataSeq
qiime tools export --input-path taxonomy/RefTaxo.qza --output-path export/taxonomy/RefTaxo
  
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RepSeq

qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_RepSeq_visual
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_ConRepSeq_visual
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RarRepSeq.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_RarRepSeq_visual

qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RepSeq.qza --output-path export/taxonomy/taxonomy_reads-per-batch_RepSeq
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza --output-path export/taxonomy/taxonomy_reads-per-batch_ConRepSeq
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza --output-path export/taxonomy/taxonomy_reads-per-batch_RarRepSeq


###############################################################
### For ITS
###############################################################

echo ###############################################################
echo ITS
echo ###############################################################


WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_ITS
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_ITS/visual

DATABASE=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files
TMPDIR=/scratch_vol0

# Aim: classify reads by taxon using a fitted classifier

# https://docs.qiime2.org/2019.10/tutorials/moving-pictures/
# In this step, you will take the denoised sequences from step 5 (rep-seqs.qza) and assign taxonomy to each sequence (phylum -> class -> …genus -> ). 
# This step requires a trained classifer. You have the choice of either training your own classifier using the q2-feature-classifier or downloading a pretrained classifier.

# https://docs.qiime2.org/2019.10/tutorials/feature-classifier/


# Aim: Import data to create a new QIIME 2 Artifact
# https://gitlab.com/IAC_SolVeg/CNRT_BIOINDIC/-/blob/master/snk/12_qiime2_taxonomy


cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate qiime2-2021.4

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p taxonomy
mkdir -p export/taxonomy

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

# ITS: gITS7-ITS4
# The ITS2 region of the 18S nuclear ribosomal RNA gene for the fungal community was amplified using the primers 18S-Fwd-ITS7 5’- GTGARTCATCGAATCTTTG-3′ (Ihrmark et al., 2012) and 18S-Rev-ITS4 5’-TCCTCCGCTTATTGATATGC-3′ (White et al., 1990). 

# NEW DATABASE UNITE :
# sh_taxonomy_qiime_ver8_dynamic_s_10.05.2021.txt
# sh_refs_qiime_ver8_dynamic_s_10.05.2021.fasta
# from https://plutof.ut.ee/#/doi/10.15156/BIO/1264763
# Originaly from https://unite.ut.ee/repository.php
# When using this resource, please cite it as follows:
# Abarenkov, Kessy; Zirk, Allan; Piirmann, Timo; Pöhönen, Raivo; Ivanov, Filipp; Nilsson, R. Henrik; Kõljalg, Urmas (2021): UNITE QIIME release for Fungi 2. Version 10.05.2021. UNITE Community. https://doi.org/10.15156/BIO/1264763 
# Includes global and 97% singletons.

# OLD = /scratch_vol0/fungi/Diversity_in_Mare_yam_crop/98_database_files/ITS2/Taxonomy-UNITE-V7-S-2017.12.01-dynamic.txt

qiime tools import --type 'FeatureData[Taxonomy]' \
  --input-format HeaderlessTSVTaxonomyFormat \
  --input-path /home/fungi/Mayotte_microorganism_colonisation/98_database_files/sh_taxonomy_qiime_ver8_dynamic_s_10.05.2021.txt \
  --output-path taxonomy/RefTaxo.qza



# You will need to importe the "Sequence-UNITE-V7-S-2017.12.01-dynamic.fasta" file by yourself because it's to big for beeing upload by GitHub.
# You can donwload it from here : https://gitlab.com/IAC_SolVeg/CNRT_BIOINDIC/-/tree/master/inp/qiime2/taxonomy/ITS

# OLD = /scratch_vol0/fungi/Diversity_in_Mare_yam_crop/98_database_files/ITS2/Sequence-UNITE-V7-S-2017.12.01-dynamic.fasta

qiime tools import --type 'FeatureData[Sequence]' \
  --input-path /home/fungi/Mayotte_microorganism_colonisation/98_database_files/sh_refs_qiime_ver8_dynamic_s_10.05.2021.fasta \
  --output-path taxonomy/DataSeq.qza

# Fungal ITS classifiers trained on the UNITE reference database do NOT benefit
# from extracting / trimming reads to primer sites.
# We recommend training UNITE classifiers on the full reference sequences !!!

# Furthermore, we recommend the 'developer' sequences
# (located within the QIIME-compatible release download),
# because the standard versions of the sequences have already been trimmed to
# the ITS region, excluding portions of flanking rRNA genes that may be present
# in amplicons generated with standard ITS primers.

# Aim: Rename import ITS DataSeq in ITS RefSeq for training.

cp taxonomy/DataSeq.qza taxonomy/RefSeq.qza

# Now in order to deal with the "no left space" problem, we will sned temporarly the files in the SCRATCH part of the cluster, I directly did this step in local and then upload the file in cluster

# Aim: Create a scikit-learn naive_bayes classifier for reads

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads taxonomy/RefSeq.qza \
  --i-reference-taxonomy taxonomy/RefTaxo.qza \
  --o-classifier taxonomy/Classifier.qza

# Aim: Classify reads by taxon using a fitted classifier
# --p-reads-per-batch 1000

qiime feature-classifier classify-sklearn \
   --i-classifier taxonomy/Classifier.qza \
   --i-reads core/ConRepSeq.qza \
   --o-classification taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza
   
qiime feature-classifier classify-sklearn \
  --i-classifier taxonomy/Classifier.qza \
  --i-reads core/RepSeq.qza \
  --o-classification taxonomy/taxonomy_reads-per-batch_RepSeq.qza

qiime feature-classifier classify-sklearn \
  --i-classifier taxonomy/Classifier.qza \
  --i-reads core/RarRepSeq.qza \
  --o-classification taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza

# Switch to https://chmi-sops.github.io/mydoc_qiime2.html#step-9-assign-taxonomy
# --p-reads-per-batch 0 (default)

qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza \
  --o-visualization taxonomy/taxonomy_reads-per-batch_RarRepSeq.qzv

qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza \
  --o-visualization taxonomy/taxonomy_reads-per-batch_ConRepSeq.qzv
  
qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
  --o-visualization taxonomy/taxonomy_reads-per-batch_RepSeq.qzv  


# Now create a visualization of the classified sequences.
  
qiime taxa barplot \
  --i-table core/Table.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RepSeq.qzv

qiime taxa barplot \
  --i-table core/ConTable.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq.qzv
  
qiime taxa barplot \
  --i-table core/RarTable.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq.qzv  

# qiime tools export --input-path taxonomy/Classifier.qza --output-path export/taxonomy/Classifier
qiime tools export --input-path taxonomy/RefSeq.qza --output-path export/taxonomy/RefSeq
qiime tools export --input-path taxonomy/DataSeq.qza --output-path export/taxonomy/DataSeq
qiime tools export --input-path taxonomy/RefTaxo.qza --output-path export/taxonomy/RefTaxo
  
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RepSeq

qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_RepSeq_visual
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_ConRepSeq_visual
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RarRepSeq.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_RarRepSeq_visual

qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RepSeq.qza --output-path export/taxonomy/taxonomy_reads-per-batch_RepSeq
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza --output-path export/taxonomy/taxonomy_reads-per-batch_ConRepSeq
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza --output-path export/taxonomy/taxonomy_reads-per-batch_RarRepSeq



###############################################################
### For TUFA
###############################################################

echo ###############################################################
echo TUFA
echo ###############################################################


WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_TUFA
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_TUFA/visual

DATABASE=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files
TMPDIR=/scratch_vol0

# Aim: classify reads by taxon using a fitted classifier

# https://docs.qiime2.org/2019.10/tutorials/moving-pictures/
# In this step, you will take the denoised sequences from step 5 (rep-seqs.qza) and assign taxonomy to each sequence (phylum -> class -> …genus -> ). 
# This step requires a trained classifer. You have the choice of either training your own classifier using the q2-feature-classifier or downloading a pretrained classifier.

# https://docs.qiime2.org/2019.10/tutorials/feature-classifier/


# Aim: Import data to create a new QIIME 2 Artifact
# https://gitlab.com/IAC_SolVeg/CNRT_BIOINDIC/-/blob/master/snk/12_qiime2_taxonomy


cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate qiime2-2021.4

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

threads=FALSE

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p taxonomy
mkdir -p export/taxonomy

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

# TUFA: gTUFA7-TUFA4
# The TUFA2 region of the 18S nuclear ribosomal RNA gene for the fungal community was amplified using the primers 18S-Fwd-TUFA7 5’- GTGARTCATCGAATCTTTG-3′ (Ihrmark et al., 2012) and 18S-Rev-TUFA4 5’-TCCTCCGCTTATTGATATGC-3′ (White et al., 1990). 

# NEW DATABASE UNITE :
# sh_taxonomy_qiime_ver8_dynamic_s_10.05.2021.txt
# sh_refs_qiime_ver8_dynamic_s_10.05.2021.fasta
# from https://plutof.ut.ee/#/doi/10.15156/BIO/1264763
# Originaly from https://unite.ut.ee/repository.php
# When using this resource, please cite it as follows:
# Abarenkov, Kessy; Zirk, Allan; Piirmann, Timo; Pöhönen, Raivo; Ivanov, Filipp; Nilsson, R. Henrik; Kõljalg, Urmas (2021): UNITE QIIME release for Fungi 2. Version 10.05.2021. UNITE Community. https://doi.org/10.15156/BIO/1264763 
# Includes global and 97% singletons.

# OLD = /scratch_vol0/fungi/Diversity_in_Mare_yam_crop/98_database_files/TUFA2/Taxonomy-UNITE-V7-S-2017.12.01-dynamic.txt

## qiime tools import --type 'FeatureData[Taxonomy]' \
##   --input-format HeaderlessTSVTaxonomyFormat \
##   --input-path /scratch_vol0/fungi/Pycnandra/98_database_files/TUFA/sh_taxonomy_qiime_ver8_dynamic_s_10.05.2021.txt \
##   --output-path taxonomy/RefTaxo.qza

# You will need to importe the "Sequence-UNITE-V7-S-2017.12.01-dynamic.fasta" file by yourself because it's to big for beeing upload by GitHub.
# You can donwload it from here : https://gitlab.com/IAC_SolVeg/CNRT_BIOINDIC/-/tree/master/inp/qiime2/taxonomy/TUFA

# OLD = /scratch_vol0/fungi/Diversity_in_Mare_yam_crop/98_database_files/TUFA2/Sequence-UNITE-V7-S-2017.12.01-dynamic.fasta

## qiime tools import --type 'FeatureData[Sequence]' \
##   --input-path /scratch_vol0/fungi/Pycnandra/98_database_files/TUFA/sh_refs_qiime_ver8_dynamic_s_10.05.2021.fasta \
##   --output-path taxonomy/DataSeq.qza
## 
# Fungal TUFA classifiers trained on the UNITE reference database do NOT benefit
# from extracting / trimming reads to primer sites.
# We recommend training UNITE classifiers on the full reference sequences !!!

# Furthermore, we recommend the 'developer' sequences
# (located within the QIIME-compatible release download),
# because the standard versions of the sequences have already been trimmed to
# the TUFA region, excluding portions of flanking rRNA genes that may be present
# in amplicons generated with standard TUFA primers.

# Aim: Rename import TUFA DataSeq in TUFA RefSeq for training.

## cp taxonomy/DataSeq.qza taxonomy/RefSeq.qza

# Now in order to deal with the "no left space" problem, we will sned temporarly the files in the SCRATCH part of the cluster, I directly did this step in local and then upload the file in cluster

# Aim: Create a scikit-learn naive_bayes classifier for reads

## qiime feature-classifier fit-classifier-naive-bayes \
##   --i-reference-reads taxonomy/RefSeq.qza \
##   --i-reference-taxonomy taxonomy/RefTaxo.qza \
##   --o-classifier taxonomy/Classifier.qza
## 
# Aim: Classify reads by taxon using a fitted classifier
# --p-reads-per-batch 1000

## qiime feature-classifier classify-sklearn \
##    --i-classifier taxonomy/Classifier.qza \
##    --i-reads core/ConRepSeq.qza \
##    --o-classification taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza
   
## qiime feature-classifier classify-sklearn \
##   --i-classifier taxonomy/Classifier.qza \
##   --i-reads core/RepSeq.qza \
##   --o-classification taxonomy/taxonomy_reads-per-batch_RepSeq.qza
## 
## qiime feature-classifier classify-sklearn \
##   --i-classifier taxonomy/Classifier.qza \
##   --i-reads core/RarRepSeq.qza \
##   --o-classification taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza

# https://forum.qiime2.org/t/using-rescript-to-compile-sequence-databases-and-taxonomy-classifiers-from-ncbi-genbank/15947
# for query : https://www.ncbi.nlm.nih.gov/books/NBK49540/

# https://forum.qiime2.org/t/building-a-coi-database-from-ncbi-references/16500

################################################################################################

qiime rescript get-ncbi-data \
    --p-query '(tufA[ALL] OR TufA[ALL] OR TUFA[ALL] OR tufa[ALL] NOT bacteria[ORGN]))' \
    --o-sequences taxonomy/RefTaxo.qza \
    --o-taxonomy taxonomy/DataSeq.qza \
    --p-n-jobs 5

qiime feature-classifier classify-consensus-blast \
  --i-query core/RepSeq.qza \
  --i-reference-reads taxonomy/RefTaxo.qza \
  --i-reference-taxonomy taxonomy/DataSeq.qza \
  --p-perc-identity 0.70 \
  --o-classification taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
  --verbose

qiime feature-classifier classify-consensus-vsearch \
    --i-query core/RepSeq.qza  \
    --i-reference-reads taxonomy/RefTaxo.qza \
    --i-reference-taxonomy taxonomy/DataSeq.qza \
    --p-perc-identity 0.77 \
    --p-query-cov 0.3 \
    --p-top-hits-only \
    --p-maxaccepts 1 \
    --p-strand 'both' \
    --p-unassignable-label 'Unassigned' \
    --p-threads 12 \
    --o-classification taxonomy/taxonomy_reads-per-batch_RepSeq_vsearch.qza
    
qiime feature-classifier classify-consensus-vsearch \
    --i-query core/RarRepSeq.qza  \
    --i-reference-reads taxonomy/RefTaxo.qza \
    --i-reference-taxonomy taxonomy/DataSeq.qza \
    --p-perc-identity 0.77 \
    --p-query-cov 0.3 \
    --p-top-hits-only \
    --p-maxaccepts 1 \
    --p-strand 'both' \
    --p-unassignable-label 'Unassigned' \
    --p-threads 12 \
    --o-classification taxonomy/taxonomy_reads-per-batch_RarRepSeq_vsearch.qza

#qiime feature-classifier classify-consensus-blast \
#  --i-query core/RarRepSeq.qza \
#  --i-reference-reads taxonomy/RefTaxo.qza \
#  --i-reference-taxonomy taxonomy/DataSeq.qza \
#  --p-perc-identity 0.97 \
#  --o-classification taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza \
#  --verbose

# Switch to https://chmi-sops.github.io/mydoc_qiime2.html#step-9-assign-taxonomy
# --p-reads-per-batch 0 (default)

#qiime metadata tabulate \
#  --m-input-file taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza \
#  --o-visualization taxonomy/taxonomy_reads-per-batch_RarRepSeq.qzv

## qiime metadata tabulate \
##   --m-input-file taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza \
##   --o-visualization taxonomy/taxonomy_reads-per-batch_ConRepSeq.qzv

#qiime metadata tabulate \
#  --m-input-file taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
#  --o-visualization taxonomy/taxonomy_reads-per-batch_RepSeq.qzv  
  
  qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy_reads-per-batch_RepSeq_vsearch.qza \
  --o-visualization taxonomy/taxonomy_reads-per-batch_RepSeq_vsearch.qzv  

  qiime metadata tabulate \
  --m-input-file taxonomy/taxonomy_reads-per-batch_RarRepSeq_vsearch.qza \
  --o-visualization taxonomy/taxonomy_reads-per-batch_RarRepSeq_vsearch.qzv  

# Now create a visualization of the classified sequences.
  
# qiime taxa barplot \
#  --i-table core/Table.qza \
#  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
#  --m-metadata-file $DATABASE/sample-metadata.tsv \
#  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RepSeq.qzv

## qiime taxa barplot \
##   --i-table core/ConTable.qza \
##   --i-taxonomy taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza \
##   --m-metadata-file $DATABASE/sample-metadata.tsv \
##   --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq.qzv

# qiime taxa barplot \
#  --i-table core/RarTable.qza \
#  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza \
#  --m-metadata-file $DATABASE/sample-metadata.tsv \
#  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq.qzv  

 qiime taxa barplot \
  --i-table core/RarTable.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RarRepSeq_vsearch.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq_vsearch.qzv 
  
  
   qiime taxa barplot \
  --i-table core/RarTable.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RepSeq_vsearch.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RepSeq_vsearch.qzv 

# # qiime tools export --input-path taxonomy/Classifier.qza --output-path export/taxonomy/Classifier
# qiime tools export --input-path taxonomy/RefSeq.qza --output-path export/taxonomy/RefSeq
#qiime tools export --input-path taxonomy/DataSeq.qza --output-path export/taxonomy/DataSeq
#qiime tools export --input-path taxonomy/RefTaxo.qza --output-path export/taxonomy/RefTaxo
  
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq_vsearch.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq_vsearch
## qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq
## qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RepSeq
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RepSeq_vsearch.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RepSeq_vsearch

#qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_RepSeq_visual
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RepSeq_vsearch.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_RepSeq_vsearch_visual
## qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_ConRepSeq_visual
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RarRepSeq_vsearch.qzv --output-path export/taxonomy/taxonomy_reads-per-batch_RarRepSeq_vsearch_visual

qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RarRepSeq_vsearch.qza --output-path export/taxonomy/taxonomy_reads-per-batch_RarRepSeq_vsearch
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RepSeq_vsearch.qza --output-path export/taxonomy/taxonomy_reads-per-batch_RepSeq_vsearch
## qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza --output-path export/taxonomy/taxonomy_reads-per-batch_ConRepSeq
qiime tools export --input-path taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza --output-path export/taxonomy/taxonomy_reads-per-batch_RarRepSeq
