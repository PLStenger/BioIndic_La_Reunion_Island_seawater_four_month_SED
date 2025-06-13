#!/usr/bin/env bash

WORKING_DIRECTORY=/home/fungi/BioIndic_La_Reunion_Island_Lagoon_II/03_cleaned_data/Original_reads_16S
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_16S

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p $OUTPUT

# You need a "manifest" for explaining and importing your data :
# In the fastq manifest formats, a manifest file maps sample identifiers to fastq.gz or fastq absolute filepaths that contain sequence and quality data for the sample, and indicates the direction of the reads in each fastq.gz / fastq absolute filepath. The manifest file will generally be created by you, and it is designed to be a simple format that doesn’t put restrictions on the naming of the demultiplexed fastq.gz / fastq files, since there is no broadly used naming convention for these files. There are no restrictions on the name of the manifest file.
# See https://docs.qiime2.org/2018.8/tutorials/importing/

MANIFEST=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/manifest_16S
TMPDIR=/scratch_vol0

###############################################################
### For importing your data in a Qiime2 format
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
mkdir -p $OUTPUT/core
mkdir -p $OUTPUT/visual

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
			    --input-path  $MANIFEST \
			    --output-path $OUTPUT/core/demux.qza \
			    --input-format PairedEndFastqManifestPhred33V2

cd $OUTPUT

# qiime demux summarize --i-data core/demux.qza --o-visualization visual/demux.qzv

# for vizualisation :
# https://view.qiime2.org

# qiime tools export --input-path visual/demux.qzv --output-path export/visual/demux
# qiime tools export --input-path core/demux.qza --output-path export/core/demux

WORKING_DIRECTORY=/home/fungi/BioIndic_La_Reunion_Island_Lagoon_II/03_cleaned_data/Original_reads_18S
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_18S

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p $OUTPUT

# You need a "manifest" for explaining and importing your data :
# In the fastq manifest formats, a manifest file maps sample identifiers to fastq.gz or fastq absolute filepaths that contain sequence and quality data for the sample, and indicates the direction of the reads in each fastq.gz / fastq absolute filepath. The manifest file will generally be created by you, and it is designed to be a simple format that doesn’t put restrictions on the naming of the demultiplexed fastq.gz / fastq files, since there is no broadly used naming convention for these files. There are no restrictions on the name of the manifest file.
# See https://docs.qiime2.org/2018.8/tutorials/importing/

MANIFEST=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/manifest_18S
TMPDIR=/scratch_vol0

###############################################################
### For importing your data in a Qiime2 format
###############################################################

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p $OUTPUT/core
mkdir -p $OUTPUT/visual

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
			    --input-path  $MANIFEST \
			    --output-path $OUTPUT/core/demux.qza \
			    --input-format PairedEndFastqManifestPhred33V2

cd $OUTPUT

# qiime demux summarize --i-data core/demux.qza --o-visualization visual/demux.qzv

# for vizualisation :
# https://view.qiime2.org

# qiime tools export --input-path visual/demux.qzv --output-path export/visual/demux
# qiime tools export --input-path core/demux.qza --output-path export/core/demux


WORKING_DIRECTORY=/home/fungi/BioIndic_La_Reunion_Island_Lagoon_II/03_cleaned_data/Original_reads_ITS
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_ITS

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p $OUTPUT

# You need a "manifest" for explaining and importing your data :
# In the fastq manifest formats, a manifest file maps sample identifiers to fastq.gz or fastq absolute filepaths that contain sequence and quality data for the sample, and indicates the direction of the reads in each fastq.gz / fastq absolute filepath. The manifest file will generally be created by you, and it is designed to be a simple format that doesn’t put restrictions on the naming of the demultiplexed fastq.gz / fastq files, since there is no broadly used naming convention for these files. There are no restrictions on the name of the manifest file.
# See https://docs.qiime2.org/2018.8/tutorials/importing/

MANIFEST=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/manifest_ITS
TMPDIR=/scratch_vol0

###############################################################
### For importing your data in a Qiime2 format
###############################################################

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p $OUTPUT/core
mkdir -p $OUTPUT/visual

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
			    --input-path  $MANIFEST \
			    --output-path $OUTPUT/core/demux.qza \
			    --input-format PairedEndFastqManifestPhred33V2

cd $OUTPUT

# qiime demux summarize --i-data core/demux.qza --o-visualization visual/demux.qzv

# for vizualisation :
# https://view.qiime2.org

# qiime tools export --input-path visual/demux.qzv --output-path export/visual/demux
# qiime tools export --input-path core/demux.qza --output-path export/core/demux


WORKING_DIRECTORY=/home/fungi/BioIndic_La_Reunion_Island_Lagoon_II/03_cleaned_data/Original_reads_TUFA
OUTPUT=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/05_QIIME2/Original_reads_TUFA

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p $OUTPUT

# You need a "manifest" for explaining and importing your data :
# In the fastq manifest formats, a manifest file maps sample identifiers to fastq.gz or fastq absolute filepaths that contain sequence and quality data for the sample, and indicates the direction of the reads in each fastq.gz / fastq absolute filepath. The manifest file will generally be created by you, and it is designed to be a simple format that doesn’t put restrictions on the naming of the demultiplexed fastq.gz / fastq files, since there is no broadly used naming convention for these files. There are no restrictions on the name of the manifest file.
# See https://docs.qiime2.org/2018.8/tutorials/importing/

MANIFEST=/scratch_vol0/fungi/BioIndic_La_Reunion_Island_seawater_four_month_SED/98_database_files/manifest_TUFA
TMPDIR=/scratch_vol0

###############################################################
### For importing your data in a Qiime2 format
###############################################################

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate /scratch_vol0/fungi/envs/qiime2-amplicon-2024.10

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p $OUTPUT/core
mkdir -p $OUTPUT/visual

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol0/fungi'
echo $TMPDIR

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
			    --input-path  $MANIFEST \
			    --output-path $OUTPUT/core/demux.qza \
			    --input-format PairedEndFastqManifestPhred33V2

cd $OUTPUT

# qiime demux summarize --i-data core/demux.qza --o-visualization visual/demux.qzv

# for vizualisation :
# https://view.qiime2.org

# qiime tools export --input-path visual/demux.qzv --output-path export/visual/demux
# qiime tools export --input-path core/demux.qza --output-path export/core/demux
