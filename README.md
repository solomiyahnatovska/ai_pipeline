# ai_pipeline
This repository contains the workflow for running the GATK workflow from FASTqs to analysis ready BAMs, to variant calling, annotation, and filtering for likely pathogenic variants 

# first download cromwell 88 (this version is what works with Navneet's modification scripts)
wget https://github.com/broadinstitute/cromwell/releases/download/88/cromwell-88.jar

## make copies of Navneets scripts:
# add_gb.sh - changes the memory specification to a format the slurm accepts
# cromwell_conf.sh - configures cromwell to run on slurm with singularity (converts the docker)
# call_cromwell.sh - script for running GATK-SV (Genome Analysis Toolkit - Structural Variants) using Cromwell 


# Follow instructions on gatk to make sure all the dependencies are intalled:
https://gatk.broadinstitute.org/hc/en-us/articles/360046877112-GATK-on-local-HPC-infrastructure

module spider java/21.0.1
# sbt not needed because cromwell-88.jar is precompiled


# clone the gatk4-germline-snps-indels repository from github : https://github.com/gatk-workflows/gatk4-germline-snps-indels?tab=readme-ov-file

git clone https://github.com/gatk-workflows/gatk4-germline-snps-indels.git
# manually changed the  Boolean make_gvcf = true to  Boolean make_gvcf = false
# ^ "for instances when calling variants for one or a few samples it is possible to have the workflow directly call variants and output a VCF file by setting the make_gvcf input variable to false."
# we don't want to make the gvcfs because they are space comsuming

# modify add_gb.sh : add correct path to the gatk wdl scripts
# run:
bash add_gb.sh
# modify docker_to_singularity.sh  : add correct path to the gatk wdl scripts
bash docker_to_singularity.sh
# configure cromwell using Navneet's script:
sbatch call_cromwell.sh
