version v1.0.0.2

Code framework for the PETPrep Pipeline started Aug. 12, 2025 by Cyrus Eierud and Helen Petropoulos
To process PET (FBP, FBB, TAU or FDG) in the cluster do the following:

1) Create your BIDS root directory, run the following code in that folder:
```
git clone --no-checkout https://github.com/trendscenter/Software-Trends.git
cd Software-Trends
git sparse-checkout init --no-cone
git sparse-checkout set cluster/pipelines/PET
git checkout main
chmod 775 ./cluster/pipelines/PET/code/zinit.sh
./cluster/pipelines/PET/code/zinit.sh
```
2) create a symbolic link using the following: ==ln -s /data/collaboration/ADNI_PET/cluster/images/PET/petprep_hmc.sif ./petprep_hmc.sif==
3) The current version of this image uses petprep_hmc v.0.0.6 and python 3.9.9. You can check the singularity version of the image by typing the following command:
   `singularity inspect --labels petprep_hmc.sif`
4) To run the image, make sure that singularity is in your path and type:
   `singularity exec --contain --workdir <singularity workdir>
   -B <path to data directory>:/data,/trdapps/linux-x86_64/bin/fsl-6.0.6.5:/fsl,/sysapps/ubuntu-applications/freesurfer/7.4.1/freesurfer:/freesurfer petprep_hmc.sif bash -c "export PATH=/root/.pyenv/bin:/root/.pyenv/versions/3.9.9/bin:/freesurfer/bin:/fsl/bin:$PATH && export LD_LIBRARY_PATH=/root/.pyenv/versions/3.9.9/lib && export FREESURFER_HOME=/freesurfer && export FSLDIR=/fsl && source $FSLDIR/etc/fslconf/fsl.sh && export SUBJECTS_DIR=/freesurfer/subjects && python3 /computation/run.py --bids_dir /data --output_dir /data/derivatives/petprep_hmc --analysis_level participant" 2>&1 | tee singularity.out`
