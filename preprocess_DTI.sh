 ################## Pre-processing DTI  ###############
                 echo " ################################################"
                 echo "Pre-processing DTI"
                 cd 9
                 cd NIFTI   
                 rest="DTICAP"

                 echo "Eddy current correction"
                 eddy_correct ${rest}.nii.gz  ${rest}_eddycorrected.nii.gz   -interp trilinear

                 #echo "Deobliquing ${subject}"
                 #3drefit -deoblique ${rest}.nii.gz

                 echo "Reorienting ${subject}"
                 #3dresample -orient RPI -inset ${rest}.nii.gz -prefix ${rest}_ro.nii.gz

                 echo "Skull stripping ${subject}"
                 #bet  ${rest}_eddycorrected.nii.gz    brain.nii.gz -m -R
                 bet  ${rest}_ro.nii.gz    brain.nii.gz -m -R -f 0.4
                 fslmaths ${rest}_eddycorrected.nii.gz   -mas brain_mask.nii.gz ${rest}_bet.nii.gz

                 echo "generate a registration map using the refence volume of the atlas"
                 flirt -ref ${rest}_bet.nii.gz -in  ../../../../../../../../MNI152lin_T1_1mm_brain.nii.gz -omat my_mat.mat

                 echo "register the atlas using the generated matrix"
                 flirt -ref ${rest}_bet.nii.gz -in  ../../../../../../../../aal.nii -applyxfm -init my_mat.mat -out atlas_reg.nii.gz -interp nearestneighbour

 
 
                 echo "Generate Connectome matrix"
                 cp ../../../../../../../../*.py .
                 python  build_connectome.py 
