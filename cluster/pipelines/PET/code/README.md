Code framework for the PETPrep Pipeline started Aug. 12, 2025 by Cyrus Eierud and Helen Petropoulos

version 1.0.0.2

To process PET (FBP, FBB, TAU or FDG) in the cluster do the following:

Create your BIDS root directory, run the following code in that folder:
```
git clone --no-checkout https://github.com/trendscenter/Software-Trends.git
cd Software-Trends
git sparse-checkout init --no-cone
git sparse-checkout set cluster/pipelines/PET
git checkout main
chmod 775 ./cluster/pipelines/PET/code/zinit.sh
./cluster/pipelines/PET/code/zinit.sh
```
The directory contains all of the software for running PETPrep.m in matlab. In addition, there are example slurm submission scripts to run freesurfer on T1 structural images and also for running petprep_hmc (head motion correction). There is a singularity image available for petprep_hmc. The version for this is petprep_hmc 0.0.6 and python 3.9.9 (later than June 2023). To check the singularity image version, make sure that singularity is in your path and type:
```
singularity inspect --labels petprep_hmc.sif
```
The singularity image can be symbolically linked to a working directory using the following command:
```
ln -s /data/collaboration/ADNI_PET/cluster/images/PET/petprep_hmc.sif ./petprep_hmc.sif
```
and can be run using the `slurm_PET_petprep_hmc.sh` file.
