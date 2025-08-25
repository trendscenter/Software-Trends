version 1.0.0.2

This github code directory contains scripts to preprocess PET data according to NeuroMark standards. To obtain the software, cd into the working directory and execute the following:
```
zinit.sh
```
The directory contains all of the software for running PETPrep.m in matlab. In addition, there are example slurm submission scripts to run freesurfer on T1 structural images and also for running petprep_hmc (head motion correction). There is a singularity image available for petprep_hmc. The version for this is petprep_hmc 0.0.6 and python 3.9.9. To check the singularity image version, make sure that singularity is in your path and type:
```
singularity inspect --labels petprep_hmc.sif
```
The singularity image can be symbolically linked to a working directory using the following command:
```
ln -s /data/collaboration/ADNI_PET/cluster/images/PET/petprep_hmc.sif ./petprep_hmc.sif
```
