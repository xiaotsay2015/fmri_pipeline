#!/bin/bash
# This shebang line indicates that the script should be run using Bash.

# ======================================================================
# Dace Apšvalka (MRC CBU 2023)
# ======================================================================
# This section provides the script's author information and the date.

# set -eu
# 'set -eu' is a safety feature. 'e' means to exit the script when a command fails.
# 'u' treats unset variables as an error and exits immediately.

# The script is set to receive a project path as an argument when submitting the function.
# However, the next line has hardcoded the path instead of using the passed argument.
#PROJECT_PATH=/group/plasticity/Projects/JT_Semantomotor #${1}
# For now, the project path is hardcoded here.
PROJECT_PATH=/group/plasticity/Projects/JT_Semantomotor

# The next line, which is commented out, would set PROJECT_PATH to the absolute path of the first script argument.
#PROJECT_PATH=("$(cd "$(dirname "$1")" && pwd)")

# This line seems to be a typo or stray character, it might cause a syntax error.
s

# Print the project path to the console.
echo $PROJECT_PATH

#-----------------------------------------------------------
# Where to output jobs
#-----------------------------------------------------------
# Define a directory for job outputs inside the work directory of the project.
JOB_DIR="$PROJECT_PATH"/work/jobs

# Create the JOB_DIR directory if it does not exist.
mkdir -p "$JOB_DIR"

# Change the working directory to JOB_DIR or exit if it fails.
cd "$JOB_DIR" || exit

# Define a pattern to select specific subjects. Here it is set to "sub-04".
# In the commented out version, it's set to match any subject ID starting with "sub-0" followed by one digit.
pattern="sub-01"
# pattern="sub-[0-9]{2}$"

# Use 'find' to locate directories that match the pattern, and 'grep' to filter them.
# It finds all directories in the BIDS dataset that match the pattern and stores them in 'selected_subjects'.
selected_subjects=$(find ${PROJECT_PATH}/data/bids/ -maxdepth 1 -type d | grep -E "$pattern")
echo $selected_subjects

#-----------------------------------------------------------
# Submit to the _fmriprep_run script as a job array on SLURM
#-----------------------------------------------------------
# Loop through each subject's directory in 'selected_subjects'.
for d in $selected_subjects; do
    # Extract just the name of the subject directory.
    sid=$(basename "$d")     
    
    # Print the subject ID to the console.
    echo $sid
    
    # Submit a job to SLURM using 'sbatch', specifying the maximum time and CPUs per task.
    # The script to run is 'step06A_fmriprep_run.sh', with 'PROJECT_PATH' and subject ID as arguments.
    sbatch --time=7-00:00 --cpus-per-task=16 "$PROJECT_PATH"/pipeline/fmriprep_run.sh "${PROJECT_PATH}" "${sid}"
    
    # Wait for a minute before submitting the next job to avoid overloading the scheduler.
    # This is a workaround for running multiple subjects in parallel with fmriprep.
    sleep 1m
done
