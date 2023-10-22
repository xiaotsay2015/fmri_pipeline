#!/bin/bash
# This shebang line ensures that the script is executed using Bash, regardless of the user's default shell.

# Navigate to the specified directory where the task will be executed.
cd /group/plasticity/Projects/JT_Semantomotor/data/bids/sub-01/testref

# ===============================================================
# Prepare the midspace
# ===============================================================
# The following command executes a script to prepare the midspace.
# This script is likely custom and located at the specified path.

# The '-r' option may be a flag required by the script, its purpose would depend on the script's internal workings.
# The '-o' option specifies the output file of the script, in this case, it's 'sub-01_task-gesture_run-0X_sbref.nii.gz'.
# The rest of the arguments are input Nifti image files for which the midspace is to be prepared.


/group/plasticity/Projects/JT_Semantomotor/pipeline/midtransform_agt.sh -r -o sub-01_task-gesture_run-0X_sbref.nii.gz \
sub-01_task-gesture_run-01_sbref.nii.gz \
sub-01_task-gesture_run-02_sbref.nii.gz \
sub-01_task-gesture_run-03_sbref.nii.gz \
sub-01_task-gesture_run-04_sbref.nii.gz \
sub-01_task-gesture_run-05_sbref.nii.gz \

# ===============================================================

