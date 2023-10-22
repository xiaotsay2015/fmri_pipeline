#!/bin/bash

# This is done because pydeface depends on FSL. Loading the FSL module ensures that all the necessary dependencies are available in the environment.
module load fsl

# Define the project root directory
# Here, a variable 'project_dir' is being defined to store the path to the project's root directory. 
project_dir=/group/plasticity/Projects/JT_Semantomotor/

# Find all T1w files
T1w_LIST=($(eval echo "$project_dir"/data/bids/sub-*/anat/*T1w.nii.gz))

# Deface, rewriting the original files

for file in "${T1w_LIST[@]}"
do
    pydeface "$file" --outfile "$file" --force &
done

# The 'wait' command is used to wait for all background jobs to finish before proceeding to the next line of the script.
wait

# Unload the FSL module.
# This is done to clean up the environment, removing the environmental variables and changes to the PATH that were added when the FSL module was loaded.
module unload fsl

