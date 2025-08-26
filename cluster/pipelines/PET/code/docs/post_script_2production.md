# Post Script Moving Files to Production

Date: 8/26/2025
By: Cyrus Eierud & Helen Petropoulos

First all the PET scripts (FreeSurfer, MC, PetPrep, intensity normalisation) have been run successfully and quality assured similar as following:
- All original PET and T1s have been collected to the root BIDS directory
- All scripts have been run
- All QC has been done to https://docs.google.com/spreadsheets/d/1ujWI1YUYLJj9URVRmd4W2ib9e5nP-j2cJ82hFlnV6JU/edit?gid=385395271#gid=385395271

Then we should move the results to production the following way
- Before we do any more file manipiiulation we zip all the subjects, including all the files into zip files with file side cars
  - Zip file may be named date (starting with year) tracer, source of subjects, number of subjects, e.g., dte-250826_trc-tau_source-adni_subjectsN-150.zip
  - Include the code directory with all the logs into the backup
  - Text file side car should be named identically as the zip file except that it has the suffix _readme.txt, e.g., dte-250826_trc-tau_source-adni_subjectsN-150_readme.txt
    - The readme files should start with a text describing the what processing was done to the subjects in the zip file (could just be a copy and paste of this text), followed by a list of all the subject IDs that are included in the zip file
  - Please keep the zip files smaller than 3GB
  - If the all subjects do not fit in a single file and you are packaging multiple zip-files from same project starting in the night and continuing next day the same project should still have the same date (to keep them together) and since they are multiple files we should have multiple packages so example of zip file names could be dte-250826_trc-tau_source-adni_subjectsN-150_pack1.zip, dte-250826_trc-tau_source-adni_subjectsN-150_pack2.zip dte-250826_trc-tau_source-adni_subjectsN-150_pack3.zip
- After the zip file is created we create a BIDS directory under /data/qneuromark/Data/ADNI/PET_tracers
  - If a previous location already exists where these files should be amended, that is the the first option to place your newly created files
  - Otherwise please create a new fitting folder name to host your BIDS files
  - In this BIDS dir there should not be any code directory nor 
- Origiinal (unprocessed) PET and T1 files existing in the root BIDS directory should be moved to the designated folder under /data/qneuromark/Data/ADNI/PET_tracers. This included PET and T1s that did not pass quality assurance
- Create directories needed under the /data/qneuromark/Data/ADNI/PET_tracers for the derivatives
- Move the following files for all subjects that passed quality assurance, where XXXX is the subject number and YYMMDD is the year, month and date, to its location it belongs in accordance with BIDS specifications under /data/qneuromark/Data/ADNI/PET_tracers/derivatives
  - derivatives/GIFT-BIDS/* (all subjects that passed quality assurance)
  - derivatives/petprep_hmc/sub-XXXX/ses-YYMMDD/sub-XXXX_ses-YYMMDD_desc-confounds_timeseries.tsv
  - derivatives/PETPrep/sub-XXXX/ses-YYMMDD/anat/sub-XXXX_ses-YYMMDD_space-T1w_desc-brain_mask.nii.gz
  - derivatives/PETPrep/sub-XXXX/ses-YYMMDD/pet/agtm/gtm.stats.dat
  - derivatives/PETPrep/sub-XXXX/ses-YYMMDD/pet/sub-XXXX_ses-YYMMDD_pvc-nopvc_desc-mc_tacs.tsv
  - derivatives/PETPrep/sub-XXXX/ses-YYMMDD/pet/sub-XXXX_ses-YYMMDD_space-mni305_pvc-nopvc_desc-preproc_pet.nii.gz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/orig.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/T1.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/brainmask.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/norm.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/brain.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/wm.seg.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/wm.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/aseg.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/aparc+aseg.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/orig/001.mgz
  - derivatives/freesurfer/sub-XXXX_ses-YYMMDD/mri/aseg.mgz

After all of these steps you may have files in the script directories, but all of those files should now have a copy in the zip files you created and therefore you may delete the script files that are left.
Please notify ceierud@gsu.edu where the zip files are located so that Cyrus can store the zip files on an external backup.
 
