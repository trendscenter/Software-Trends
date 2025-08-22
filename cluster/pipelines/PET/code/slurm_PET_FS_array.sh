#!/bin/bash

# February 2025, author Helen Petropoulos

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=48:00:00
#SBATCH --array=0-999
#SBATCH --mem=20g
#SBATCH -p qTRD
#SBATCH -J <PET_FS>
#SBATCH -e PET_FS_%A.err
#SBATCH -o PET_FS_%A.out
#SBATCH -A trends53c17
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL
#SBATCH --oversubscribe

sleep 10s

# Some of the code here has been borrowed from https://rcs.ucalgary.ca/Freesurfer_on_ARC#Multiple_Scans_Reconstruction_in_Parallel_with_a_Job_Array

module add freesurfer/7.4.1
source $FREESURFER_HOME/SetUpFreeSurfer.sh

((i=SLURM_ARRAY_TASK_ID-1))

subjects_file=/data/collaboration/ADNI_PET/tau/bids_11Feb25/subjects_list_FS.txt
if [ ! -e "${subjects_file}" ]; then
  >&2 echo "error: subjects_file does not exist"
  exit 1
fi

# read the subjects from the subjects file
IFS=$'\n'; subjects=( $(cat "${subjects_file}") );

subject=${subjects[${i}]}
subject_id=`echo $subject | awk -F \/ '{print $1"_"$2}'`
#subject_id=`basename $subject .nii`
subjects_dir=/data/collaboration/ADNI_PET/tau/bids_11Feb25
output_dir=/data/collaboration/ADNI_PET/tau/bids_11Feb25/derivatives/freesurfer

recon-all -subjid ${subject_id} -i ${subjects_dir}/${subject} -all -sd ${output_dir}

sleep 30s

