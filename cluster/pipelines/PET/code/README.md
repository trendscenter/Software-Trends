version 1.0.1

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
2) create a symbilic link using the following: ln -s /data/collaboration/ADNI_PET/cluster/images/PET/petprep_hmc.sif ./petprep_hmc.sif 
lease make sure your singularity version is later than June 2023, perhaps by using the command singularity inspect --labels my_singularity_file_image.sif)
