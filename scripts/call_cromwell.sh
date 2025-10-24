#!/bin/bash

#SBATCH --job-name=gatk_sv
#SBATCH --mail-user=navneet.aujla@sinaihealth.ca
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --time=72:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --output=logs/gatk_max_giab_%j.out
#SBATCH --error=logs/gatk_max_giab_%j.err
#SBATCH --requeue

module load StdEnv/2023
module load java/17.0.6
module load apptainer/1.3.4


## soft-link 8 jobs, bind $SCRATCH, change men mem to 12 and kept -B cwd, edited manta 3 job per cpu + 2 gb per job, whamg changed x cpu_cores to 8 (2X4)
export JAVA_TOOL_OPTIONS="-Xmx16g"

java -Dlog.level=DEBUG -Dconfig.file=cromwell.conf -jar cromwell-88.jar run /scratch/aujlana/gatk_sv_v.1.0.2/wdl/GatherSampleEvidenceBatch.wdl --inputs  GatherSampleEvidenceBatch_cram.json \
--metadata-output metadata_${SLURM_JOB_ID}.json