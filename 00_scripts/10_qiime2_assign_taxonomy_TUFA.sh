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
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

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

# "#" ici car deja fait auparavant
#qiime rescript get-ncbi-data \
#    --p-query '(tufA[ALL] OR TufA[ALL] OR TUFA[ALL] OR tufa[ALL] NOT bacteria[ORGN]))' \
#    --o-sequences taxonomy/RefTaxo.qza \
#    --o-taxonomy taxonomy/DataSeq.qza \
#    --p-n-jobs 5

qiime feature-classifier classify-consensus-blast \
  --i-query core/RepSeq.qza \
  --i-reference-reads taxonomy/RefTaxo.qza \
  --i-reference-taxonomy taxonomy/DataSeq.qza \
  --p-perc-identity 0.70 \
  --o-classification taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
  --output-dir taxonomy \
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
    --output-dir taxonomy \
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
