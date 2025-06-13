#!/usr/bin/env bash

# Run all scripts :

 time nohup bash 01_quality_check_by_FastQC.sh &> 01_quality_check_by_FastQC.out
 time nohup bash 02_trimmomatic_q30.sh &> 02_trimmomatic_q30.out
 time nohup bash 03_check_quality_of_cleaned_data.sh &> 03_check_quality_of_cleaned_data.out
 time nohup bash 05_qiime2_import_PE.sh &> 05_qiime2_import_PE.out
 time nohup bash 06_qiime2_denoise_PE_no_contamination.sh &> 06_qiime2_denoise_PE_no_contamination.out
 time nohup bash 07_qiime2_tree_PE_Table.sh &> 07_qiime2_tree_PE_Table.out
# time nohup bash 08_qiime2_rarefaction_PE.sh &> 08_qiime2_rarefaction_PE.out
# time nohup bash 09_qiime2_calculate_and_explore_diversity_metrics_PE.sh &> 09_qiime2_calculate_and_explore_diversity_metrics_PE.out
# time nohup bash 11_core_biom_PE.sh &> 11_core_biom_PE.out





