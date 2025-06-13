#!/usr/bin/env bash

####################################################################################
### 16S ###
####################################################################################

WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_16S
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/visual/Original_reads_16S

# Créer le répertoire de sortie si non existant (-p)
mkdir -p $OUTPUT

METADATA=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/sample-metadata.tsv
# Directory pour les fichiers temporaires
TMPDIR=/scratch_vol0

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

# Définir le répertoire temporaire pour éviter le problème d’espace
export TMPDIR='/scratch_vol0/fungi'
echo "Répertoire temporaire: $TMPDIR"

# DADA2 denoise
################
qiime dada2 denoise-paired --i-demultiplexed-seqs core/demux.qza \
 --o-table core/Table.qza  \
 --o-representative-sequences core/RepSeq.qza \
 --o-denoising-stats core/Stats.qza \
 --p-trim-left-f 0 \
 --p-trim-left-r 0 \
 --p-trunc-len-f 0 \
 --p-trunc-len-r 0 \
 --p-n-threads 4  

# Filtrage de contingence sur les features
##########################################

# Filtrer les features apparaissant dans un seul échantillon
qiime feature-table filter-features --i-table core/Table.qza \
                                    --p-min-samples 2 \
                                    --p-min-frequency 0 \
                                    --o-filtered-table core/ConTable.qza

# Filtrer les séquences basées sur le tableau de contingence
qiime feature-table filter-seqs --i-data core/RepSeq.qza \
                                --i-table core/ConTable.qza \
                                --o-filtered-data core/ConRepSeq.qza

# Résumés et visualisations
############################

qiime feature-table summarize --i-table core/Table.qza --m-sample-metadata-file $METADATA --o-visualization visual/Table.qzv
qiime feature-table summarize --i-table core/ConTable.qza --m-sample-metadata-file $METADATA --o-visualization visual/ConTable.qzv
qiime feature-table tabulate-seqs --i-data core/RepSeq.qza --o-visualization visual/RepSeq.qzv
qiime feature-table tabulate-seqs --i-data core/ConRepSeq.qza --o-visualization visual/ConRepSeq.qzv

# Export des fichiers
######################

mkdir -p export/core
mkdir -p export/visual

qiime tools export --input-path core/Table.qza --output-path export/core/Table
qiime tools export --input-path core/ConTable.qza --output-path export/core/ConTable
qiime tools export --input-path core/RepSeq.qza --output-path export/core/RepSeq
qiime tools export --input-path core/ConRepSeq.qza --output-path export/core/ConRepSeq
qiime tools export --input-path core/Stats.qza --output-path export/core/Stats

qiime tools export --input-path visual/Table.qzv --output-path export/visual/Table
qiime tools export --input-path visual/ConTable.qzv --output-path export/visual/ConTable
qiime tools export --input-path visual/RepSeq.qzv --output-path export/visual/RepSeq
qiime tools export --input-path visual/ConRepSeq.qzv --output-path export/visual/ConRepSeq

####################################################################################
### ITS ###
####################################################################################

WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_ITS
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/visual/Original_reads_ITS

# Créer le répertoire de sortie si non existant (-p)
mkdir -p $OUTPUT

METADATA=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/sample-metadata.tsv
# Directory pour les fichiers temporaires
TMPDIR=/scratch_vol0

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate qiime2-2021.4

# Définir le répertoire temporaire pour éviter le problème d’espace
export TMPDIR='/scratch_vol0/fungi'
echo "Répertoire temporaire: $TMPDIR"

# DADA2 denoise
################
qiime dada2 denoise-paired --i-demultiplexed-seqs core/demux.qza \
 --o-table core/Table.qza  \
 --o-representative-sequences core/RepSeq.qza \
 --o-denoising-stats core/Stats.qza \
 --p-trim-left-f 0 \
 --p-trim-left-r 0 \
 --p-trunc-len-f 0 \
 --p-trunc-len-r 0 \
 --p-n-threads 4  

# Filtrage de contingence sur les features
##########################################

# Filtrer les features apparaissant dans un seul échantillon
qiime feature-table filter-features --i-table core/Table.qza \
                                    --p-min-samples 2 \
                                    --p-min-frequency 0 \
                                    --o-filtered-table core/ConTable.qza

# Filtrer les séquences basées sur le tableau de contingence
qiime feature-table filter-seqs --i-data core/RepSeq.qza \
                                --i-table core/ConTable.qza \
                                --o-filtered-data core/ConRepSeq.qza

# Résumés et visualisations
############################

qiime feature-table summarize --i-table core/Table.qza --m-sample-metadata-file $METADATA --o-visualization visual/Table.qzv
qiime feature-table summarize --i-table core/ConTable.qza --m-sample-metadata-file $METADATA --o-visualization visual/ConTable.qzv
qiime feature-table tabulate-seqs --i-data core/RepSeq.qza --o-visualization visual/RepSeq.qzv
qiime feature-table tabulate-seqs --i-data core/ConRepSeq.qza --o-visualization visual/ConRepSeq.qzv

# Export des fichiers
######################

mkdir -p export/core
mkdir -p export/visual

qiime tools export --input-path core/Table.qza --output-path export/core/Table
qiime tools export --input-path core/ConTable.qza --output-path export/core/ConTable
qiime tools export --input-path core/RepSeq.qza --output-path export/core/RepSeq
qiime tools export --input-path core/ConRepSeq.qza --output-path export/core/ConRepSeq
qiime tools export --input-path core/Stats.qza --output-path export/core/Stats

qiime tools export --input-path visual/Table.qzv --output-path export/visual/Table
qiime tools export --input-path visual/ConTable.qzv --output-path export/visual/ConTable
qiime tools export --input-path visual/RepSeq.qzv --output-path export/visual/RepSeq
qiime tools export --input-path visual/ConRepSeq.qzv --output-path export/visual/ConRepSeq


####################################################################################
### 18S ###
####################################################################################

WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_18S
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/visual/Original_reads_18S

# Créer le répertoire de sortie si non existant (-p)
mkdir -p $OUTPUT

METADATA=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/sample-metadata.tsv
# Directory pour les fichiers temporaires
TMPDIR=/scratch_vol0

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate qiime2-2021.4

# Définir le répertoire temporaire pour éviter le problème d’espace
export TMPDIR='/scratch_vol0/fungi'
echo "Répertoire temporaire: $TMPDIR"

# DADA2 denoise
################
qiime dada2 denoise-paired --i-demultiplexed-seqs core/demux.qza \
 --o-table core/Table.qza  \
 --o-representative-sequences core/RepSeq.qza \
 --o-denoising-stats core/Stats.qza \
 --p-trim-left-f 0 \
 --p-trim-left-r 0 \
 --p-trunc-len-f 0 \
 --p-trunc-len-r 0 \
 --p-n-threads 4  

# Filtrage de contingence sur les features
##########################################

# Filtrer les features apparaissant dans un seul échantillon
qiime feature-table filter-features --i-table core/Table.qza \
                                    --p-min-samples 2 \
                                    --p-min-frequency 0 \
                                    --o-filtered-table core/ConTable.qza

# Filtrer les séquences basées sur le tableau de contingence
qiime feature-table filter-seqs --i-data core/RepSeq.qza \
                                --i-table core/ConTable.qza \
                                --o-filtered-data core/ConRepSeq.qza

# Résumés et visualisations
############################

qiime feature-table summarize --i-table core/Table.qza --m-sample-metadata-file $METADATA --o-visualization visual/Table.qzv
qiime feature-table summarize --i-table core/ConTable.qza --m-sample-metadata-file $METADATA --o-visualization visual/ConTable.qzv
qiime feature-table tabulate-seqs --i-data core/RepSeq.qza --o-visualization visual/RepSeq.qzv
qiime feature-table tabulate-seqs --i-data core/ConRepSeq.qza --o-visualization visual/ConRepSeq.qzv

# Export des fichiers
######################

mkdir -p export/core
mkdir -p export/visual

qiime tools export --input-path core/Table.qza --output-path export/core/Table
qiime tools export --input-path core/ConTable.qza --output-path export/core/ConTable
qiime tools export --input-path core/RepSeq.qza --output-path export/core/RepSeq
qiime tools export --input-path core/ConRepSeq.qza --output-path export/core/ConRepSeq
qiime tools export --input-path core/Stats.qza --output-path export/core/Stats

qiime tools export --input-path visual/Table.qzv --output-path export/visual/Table
qiime tools export --input-path visual/ConTable.qzv --output-path export/visual/ConTable
qiime tools export --input-path visual/RepSeq.qzv --output-path export/visual/RepSeq
qiime tools export --input-path visual/ConRepSeq.qzv --output-path export/visual/ConRepSeq

####################################################################################
### TUFA ###
####################################################################################

WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_TUFA
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/visual/Original_reads_TUFA

# Créer le répertoire de sortie si non existant (-p)
mkdir -p $OUTPUT

METADATA=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/sample-metadata.tsv
# Directory pour les fichiers temporaires
TMPDIR=/scratch_vol0

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate qiime2-2021.4

# Définir le répertoire temporaire pour éviter le problème d’espace
export TMPDIR='/scratch_vol0/fungi'
echo "Répertoire temporaire: $TMPDIR"

# DADA2 denoise
################
qiime dada2 denoise-paired --i-demultiplexed-seqs core/demux.qza \
 --o-table core/Table.qza  \
 --o-representative-sequences core/RepSeq.qza \
 --o-denoising-stats core/Stats.qza \
 --p-trim-left-f 0 \
 --p-trim-left-r 0 \
 --p-trunc-len-f 0 \
 --p-trunc-len-r 0 \
 --p-n-threads 4  

# Filtrage de contingence sur les features
##########################################

# Filtrer les features apparaissant dans un seul échantillon
qiime feature-table filter-features --i-table core/Table.qza \
                                    --p-min-samples 2 \
                                    --p-min-frequency 0 \
                                    --o-filtered-table core/ConTable.qza

# Filtrer les séquences basées sur le tableau de contingence
qiime feature-table filter-seqs --i-data core/RepSeq.qza \
                                --i-table core/ConTable.qza \
                                --o-filtered-data core/ConRepSeq.qza

# Résumés et visualisations
############################

qiime feature-table summarize --i-table core/Table.qza --m-sample-metadata-file $METADATA --o-visualization visual/Table.qzv
qiime feature-table summarize --i-table core/ConTable.qza --m-sample-metadata-file $METADATA --o-visualization visual/ConTable.qzv
qiime feature-table tabulate-seqs --i-data core/RepSeq.qza --o-visualization visual/RepSeq.qzv
qiime feature-table tabulate-seqs --i-data core/ConRepSeq.qza --o-visualization visual/ConRepSeq.qzv

# Export des fichiers
######################

mkdir -p export/core
mkdir -p export/visual

qiime tools export --input-path core/Table.qza --output-path export/core/Table
qiime tools export --input-path core/ConTable.qza --output-path export/core/ConTable
qiime tools export --input-path core/RepSeq.qza --output-path export/core/RepSeq
qiime tools export --input-path core/ConRepSeq.qza --output-path export/core/ConRepSeq
qiime tools export --input-path core/Stats.qza --output-path export/core/Stats

qiime tools export --input-path visual/Table.qzv --output-path export/visual/Table
qiime tools export --input-path visual/ConTable.qzv --output-path export/visual/ConTable
qiime tools export --input-path visual/RepSeq.qzv --output-path export/visual/RepSeq
qiime tools export --input-path visual/ConRepSeq.qzv --output-path export/visual/ConRepSeq
