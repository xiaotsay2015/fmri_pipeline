#!/bin/bash


# Load the FSL module. FSL (FMRIB Software Library) is a library of tools for analyzing FMRI, MRI and DTI brain imaging data.
# Loading a module sets up the user’s environment for the chosen software package, adding necessary environmental variables, updating the PATH, etc.
# This is done because pydeface depends on FSL. Loading the FSL module ensures that all the necessary dependencies are available in the environment.
module load fsl

# Define the project root directory
# Here, a variable 'project_dir' is being defined to store the path to the project's root directory. 
# This helps in making the script more maintainable, as this path is used multiple times in the script.
project_dir=/group/plasticity/Projects/JT_Semantomotor/

# Find all T1w files
# The 'find' command is used to search for files and directories within a directory hierarchy based on conditions you specify.
# In this line, we are searching for all T1-weighted MRI images (with 'T1w' in their filenames and a '.nii.gz' extension), 
# located within the 'anat' (anatomical) subdirectories of each subject's 'bids' directory.
# The results are stored in an array called 'T1w_LIST'.
# The 'eval' and 'echo' commands are used to ensure that the wildcard (*) is expanded to match all possible files.
T1w_LIST=($(eval echo "$project_dir"/data/bids/sub-*/anat/*T1w.nii.gz))

# Deface, rewriting the original files
# A 'for' loop is used to iterate over each file found in the previous step.
# For each file, 'pydeface' is run to deface the MRI image for anonymization, removing facial features that could be used to identify the subject.
# The '--outfile' option specifies the output file, which in this case is the same as the input file, effectively overwriting the original file.
# The '--force' option forces the overwriting of the output file if it already exists.
# The '&' at the end of the 'pydeface' command puts the command in the background, allowing the next iteration of the loop to start immediately,
# enabling parallel processing of the files.
# This is particularly useful when dealing with a large number of files, as it can significantly speed up the process.

for file in "${T1w_LIST[@]}"
do
    pydeface "$file" --outfile "$file" --force &
done

# The 'wait' command is used to wait for all background jobs to finish before proceeding to the next line of the script.
# This is important to ensure that all the 'pydeface' commands have completed before the FSL module is unloaded and the script ends.
wait

# Unload the FSL module.
# This is done to clean up the environment, removing the environmental variables and changes to the PATH that were added when the FSL module was loaded.
module unload fsl

# End of Script
# At this point, all T1-weighted images should be defaced, and the script has finished running.



