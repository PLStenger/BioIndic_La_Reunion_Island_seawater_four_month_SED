#!/usr/bin/env bash

###############
### For 16S ###
###############

WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_16S
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_16S/visual

DATABASE=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files
TMPDIR=/scratch_vol0

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p subtables
mkdir -p export/subtables

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

## ALL SAMPLES :

## 1-COP-COR1
## 1-COP-COR2
## 1-COP-COR3
## 1-COP-EAU1
## 1-COP-EAU2
## 1-COP-EAU3
## 1-COP-SED1
## 1-COP-SED2
## 1-COP-SED3
## 1-LIV-COR1
## 1-LIV-COR2
## 1-LIV-COR3
## 1-LIV-EAU1
## 1-LIV-EAU2
## 1-LIV-EAU3
## 1-LIV-SED1
## 1-LIV-SED2
## 1-LIV-SED3
## 1-TOB-COR1
## 1-TOB-COR2
## 1-TOB-COR3
## 1-TOB-EAU1
## 1-TOB-EAU2
## 1-TOB-EAU3
## 1-TOB-SED1
## 1-TOB-SED2
## 1-TOB-SED3
## 2-COP-COR1
## 2-COP-COR2
## 2-COP-COR3
## 2-COP-EAU1
## 2-COP-EAU2
## 2-COP-EAU3
## 2-COP-SED1
## 2-COP-SED2
## 2-COP-SED3
## 2-LIV-COR1
## 2-LIV-COR2
## 2-LIV-COR3
## 2-LIV-EAU1
## 2-LIV-EAU2
## 2-LIV-EAU3
## 2-LIV-SED1
## 2-LIV-SED2
## 2-LIV-SED3
## 2-TOB-COR1
## 2-TOB-COR2
## 2-TOB-COR3
## 2-TOB-EAU1
## 2-TOB-EAU2
## 2-TOB-EAU3
## 2-TOB-SED1
## 2-TOB-SED2
## 2-TOB-SED3
## CONTROL

# Aim: Filter sample from table based on a feature table or metadata

#qiime feature-table filter-samples \
#        --i-table core/RarTable.qza \
#        --m-metadata-file $DATABASE/sample-metadata.tsv \'
#        --p-where "[#SampleID] IN ('1-COP-COR1', '1-COP-COR2', '1-COP-COR3', '1-COP-EAU1', '1-COP-EAU2', '1-COP-EAU3', '1-COP-SED1', '1-COP-SED2', '1-COP-SED3', '1-LIV-COR1', '1-LIV-COR2', '1-LIV-COR3', '1-LIV-EAU1', '1-LIV-EAU2', '1-LIV-EAU3', '1-LIV-SED1', '1-LIV-SED2', '1-LIV-SED3', '1-TOB-COR1', '1-TOB-COR2', '1-TOB-COR3', '1-TOB-EAU1', '1-TOB-EAU2', '1-TOB-EAU3', '1-TOB-SED1', '1-TOB-SED2', '1-TOB-SED3', '2-COP-COR1', '2-COP-COR2', '2-COP-COR3', '2-COP-EAU1', '2-COP-EAU2', '2-COP-EAU3', '2-COP-SED1', '2-COP-SED2', '2-COP-SED3', '2-LIV-COR1', '2-LIV-COR2', '2-LIV-COR3', '2-LIV-EAU1', '2-LIV-EAU2', '2-LIV-EAU3', '2-LIV-SED1', '2-LIV-SED2', '2-LIV-SED3', '2-TOB-COR1', '2-TOB-COR2', '2-TOB-COR3', '2-TOB-EAU1', '2-TOB-EAU2', '2-TOB-EAU3', '2-TOB-SED1', '2-TOB-SED2', '2-TOB-SED3', 'CONTROL', 'ZymoBIOMICS')"  \
#        --o-filtered-table subtables/RarTable-all.qza
 
# Aim: Identify "core" features, which are features observed,
     # in a user-defined fraction of the samples
     
mv core/RarTable.qza subtables/RarTable-all.qza
        
qiime feature-table core-features \
        --i-table subtables/RarTable-all.qza \
        --p-min-fraction 0.1 \
        --p-max-fraction 1.0 \
        --p-steps 10 \
        --o-visualization visual/CoreBiom-all.qzv  
        
qiime tools export --input-path subtables/RarTable-all.qza --output-path export/subtables/RarTable-all    
qiime tools export --input-path visual/CoreBiom-all.qzv --output-path export/visual/CoreBiom-all
biom convert -i export/subtables/RarTable-all/feature-table.biom -o export/subtables/RarTable-all/table-from-biom.tsv --to-tsv
sed '1d ; s/\#OTU ID/ASV_ID/' export/subtables/RarTable-all/table-from-biom.tsv > export/subtables/RarTable-all/ASV.tsv

###############
### For 18S ###
###############

WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_18S
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_18S/visual

DATABASE=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files
TMPDIR=/scratch_vol0

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p subtables
mkdir -p export/subtables

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

# Aim: Filter sample from table based on a feature table or metadata

#qiime feature-table filter-samples \
#        --i-table core/RarTable.qza \
#        --m-metadata-file $DATABASE/sample-metadata.tsv \'
#        --p-where "[#SampleID] IN ('1-COP-COR1', '1-COP-COR2', '1-COP-COR3', '1-COP-EAU1', '1-COP-EAU2', '1-COP-EAU3', '1-COP-SED1', '1-COP-SED2', '1-COP-SED3', '1-LIV-COR1', '1-LIV-COR2', '1-LIV-COR3', '1-LIV-EAU1', '1-LIV-EAU2', '1-LIV-EAU3', '1-LIV-SED1', '1-LIV-SED2', '1-LIV-SED3', '1-TOB-COR1', '1-TOB-COR2', '1-TOB-COR3', '1-TOB-EAU1', '1-TOB-EAU2', '1-TOB-EAU3', '1-TOB-SED1', '1-TOB-SED2', '1-TOB-SED3', '2-COP-COR1', '2-COP-COR2', '2-COP-COR3', '2-COP-EAU1', '2-COP-EAU2', '2-COP-EAU3', '2-COP-SED1', '2-COP-SED2', '2-COP-SED3', '2-LIV-COR1', '2-LIV-COR2', '2-LIV-COR3', '2-LIV-EAU1', '2-LIV-EAU2', '2-LIV-EAU3', '2-LIV-SED1', '2-LIV-SED2', '2-LIV-SED3', '2-TOB-COR1', '2-TOB-COR2', '2-TOB-COR3', '2-TOB-EAU1', '2-TOB-EAU2', '2-TOB-EAU3', '2-TOB-SED1', '2-TOB-SED2', '2-TOB-SED3', 'CONTROL')"  \
#        --o-filtered-table subtables/RarTable-all.qza
 
# Aim: Identify "core" features, which are features observed,
     # in a user-defined fraction of the samples
     
mv core/RarTable.qza subtables/RarTable-all.qza
        
qiime feature-table core-features \
        --i-table subtables/RarTable-all.qza \
        --p-min-fraction 0.1 \
        --p-max-fraction 1.0 \
        --p-steps 10 \
        --o-visualization visual/CoreBiom-all.qzv  
        
qiime tools export --input-path subtables/RarTable-all.qza --output-path export/subtables/RarTable-all    
qiime tools export --input-path visual/CoreBiom-all.qzv --output-path export/visual/CoreBiom-all
biom convert -i export/subtables/RarTable-all/feature-table.biom -o export/subtables/RarTable-all/table-from-biom.tsv --to-tsv
sed '1d ; s/\#OTU ID/ASV_ID/' export/subtables/RarTable-all/table-from-biom.tsv > export/subtables/RarTable-all/ASV.tsv

###############
### For ITS ###
###############


WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_ITS
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_ITS/visual

DATABASE=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files
TMPDIR=/scratch_vol0

###############################################################
### For ITS
###############################################################

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p subtables
mkdir -p export/subtables

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

# Aim: Filter sample from table based on a feature table or metadata

#qiime feature-table filter-samples \
#        --i-table core/RarTable.qza \
#        --m-metadata-file $DATABASE/sample-metadata.tsv \'
#        --p-where "[#SampleID] IN ('1-COP-COR1', '1-COP-COR2', '1-COP-COR3', '1-COP-EAU1', '1-COP-EAU2', '1-COP-EAU3', '1-COP-SED1', '1-COP-SED2', '1-COP-SED3', '1-LIV-COR1', '1-LIV-COR2', '1-LIV-COR3', '1-LIV-EAU1', '1-LIV-EAU2', '1-LIV-EAU3', '1-LIV-SED1', '1-LIV-SED2', '1-LIV-SED3', '1-TOB-COR1', '1-TOB-COR2', '1-TOB-COR3', '1-TOB-EAU1', '1-TOB-EAU2', '1-TOB-EAU3', '1-TOB-SED1', '1-TOB-SED2', '1-TOB-SED3', '2-COP-COR1', '2-COP-COR2', '2-COP-COR3', '2-COP-EAU1', '2-COP-EAU2', '2-COP-EAU3', '2-COP-SED1', '2-COP-SED2', '2-COP-SED3', '2-LIV-COR1', '2-LIV-COR2', '2-LIV-COR3', '2-LIV-EAU1', '2-LIV-EAU2', '2-LIV-EAU3', '2-LIV-SED1', '2-LIV-SED2', '2-LIV-SED3', '2-TOB-COR1', '2-TOB-COR2', '2-TOB-COR3', '2-TOB-EAU1', '2-TOB-EAU2', '2-TOB-EAU3', '2-TOB-SED1', '2-TOB-SED2', '2-TOB-SED3', 'CONTROL')"  \
#        --o-filtered-table subtables/RarTable-all.qza
        
mv core/RarTable.qza subtables/RarTable-all.qza

 
# Aim: Identify "core" features, which are features observed,
     # in a user-defined fraction of the samples
        
qiime feature-table core-features \
        --i-table subtables/RarTable-all.qza \
        --p-min-fraction 0.1 \
        --p-max-fraction 1.0 \
        --p-steps 10 \
        --o-visualization visual/CoreBiom-all.qzv  
        
qiime tools export --input-path subtables/RarTable-all.qza --output-path export/subtables/RarTable-all    
qiime tools export --input-path visual/CoreBiom-all.qzv --output-path export/visual/CoreBiom-all
biom convert -i export/subtables/RarTable-all/feature-table.biom -o export/subtables/RarTable-all/table-from-biom.tsv --to-tsv
sed '1d ; s/\#OTU ID/ASV_ID/' export/subtables/RarTable-all/table-from-biom.tsv > export/subtables/RarTable-all/ASV.tsv




###############
### For TUFA ###
###############


WORKING_DIRECTORY=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_TUFA
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_TUFA/visual

DATABASE=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files
TMPDIR=/scratch_vol0

###############################################################
### For TUFA
###############################################################

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p subtables
mkdir -p export/subtables

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

# Aim: Filter sample from table based on a feature table or metadata

#qiime feature-table filter-samples \
#        --i-table core/RarTable.qza \
#        --m-metadata-file $DATABASE/sample-metadata.tsv \'
#        --p-where "[#SampleID] IN ('1-COP-COR1', '1-COP-COR2', '1-COP-COR3', '1-COP-EAU1', '1-COP-EAU2', '1-COP-EAU3', '1-COP-SED1', '1-COP-SED2', '1-COP-SED3', '1-LIV-COR1', '1-LIV-COR2', '1-LIV-COR3', '1-LIV-EAU1', '1-LIV-EAU2', '1-LIV-EAU3', '1-LIV-SED1', '1-LIV-SED2', '1-LIV-SED3', '1-TOB-COR1', '1-TOB-COR2', '1-TOB-COR3', '1-TOB-EAU1', '1-TOB-EAU2', '1-TOB-EAU3', '1-TOB-SED1', '1-TOB-SED2', '1-TOB-SED3', '2-COP-COR1', '2-COP-COR2', '2-COP-COR3', '2-COP-EAU1', '2-COP-EAU2', '2-COP-EAU3', '2-COP-SED1', '2-COP-SED2', '2-COP-SED3', '2-LIV-COR1', '2-LIV-COR2', '2-LIV-COR3', '2-LIV-EAU1', '2-LIV-EAU2', '2-LIV-EAU3', '2-LIV-SED1', '2-LIV-SED2', '2-LIV-SED3', '2-TOB-COR1', '2-TOB-COR2', '2-TOB-COR3', '2-TOB-EAU1', '2-TOB-EAU2', '2-TOB-EAU3', '2-TOB-SED1', '2-TOB-SED2', '2-TOB-SED3', 'CONTROL')"  \
#        --o-filtered-table subtables/RarTable-all.qza
        
mv core/RarTable.qza subtables/RarTable-all.qza

 
# Aim: Identify "core" features, which are features observed,
     # in a user-defined fraction of the samples
        
qiime feature-table core-features \
        --i-table subtables/RarTable-all.qza \
        --p-min-fraction 0.1 \
        --p-max-fraction 1.0 \
        --p-steps 10 \
        --o-visualization visual/CoreBiom-all.qzv  
        
qiime tools export --input-path subtables/RarTable-all.qza --output-path export/subtables/RarTable-all    
qiime tools export --input-path visual/CoreBiom-all.qzv --output-path export/visual/CoreBiom-all
biom convert -i export/subtables/RarTable-all/feature-table.biom -o export/subtables/RarTable-all/table-from-biom.tsv --to-tsv
sed '1d ; s/\#OTU ID/ASV_ID/' export/subtables/RarTable-all/table-from-biom.tsv > export/subtables/RarTable-all/ASV.tsv


