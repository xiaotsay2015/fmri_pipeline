#!/bin/bash
#
# This is a Slurm batch script designed to convert DICOM files to BIDS format using heudiconv.
#
# SLURM Directives:
# ------------------
#SBATCH --job-name=heudiconv      # Set the job name to "heudiconv"
#SBATCH --nodes=2                 # Request 2 nodes
#SBATCH --cpus-per-task=2         # Request 2 CPUs per task
#SBATCH --mem=4G                  # Request 4GB of memory
#SBATCH --time=1:00:00            # Set a time limit of 1 hour

# Information:
# ------------
# This script is designed to process subjects in parallel using Slurm. To use this script,
# you must run it with the sbatch command and provide an array range to process multiple subjects.
# For example, to run subjects 0 through 15, you would use:
#
# sbatch --array=0-15 ./step02_heudiconv_run.sh
#
# Paths:
# ------
# Define the paths for your project. These are essential for directing heudiconv where to find
# your DICOM files and where to save the output.

# Define the project root directory
PROJECT_PATH=/group/plasticity/Projects/JT_Semantomotor/

# Define the path to DICOM files under the project directory
DICOM_PATH=$PROJECT_PATH/data/dicom

# Define the path where to save the output data
OUTPUT_PATH=$PROJECT_PATH/data/bids

# Subject List:
# -------------
# Generate a list of subjects to process. This is pulled directly from the directories in your DICOM_PATH.

# Which subject to process (Initialize the array with one subject as an example)
SUBJECT_LIST=("01")

# Loop over each directory in your DICOM_PATH, assuming each directory is a subject
for d in "$DICOM_PATH"/*; do
    sub_id=$(basename "$d")  # Extract just the name of the directory, which is assumed to be your subject ID
    SUBJECT_LIST+=("$sub_id")  # Add this subject ID to your list
done

# Subject Indexing for Job Arrays:
# --------------------------------
# Use Slurm's job array feature to index into your list of subjects. 
# This allows you to run the same script for each subject, in parallel.
# Here, you'd modify the script to use $SLURM_ARRAY_TASK_ID, which is the index for the job array.

# Ensure that sid is set to the subject based on the job array ID. Adjust for one-based indexing if necessary.
sid=${SUBJECT_LIST[$SLURM_ARRAY_TASK_ID]}

# heudiconv Conversion:
# ---------------------
# Now, run heudiconv to convert your DICOM files to BIDS format.

heudiconv \
    -d $DICOM_PATH/{subject}/*/*.dcm \
    -o $OUTPUT_PATH \
    -f $PROJECT_PATH/pipeline/heudiconv_heuristic.py \
    -s $sid \
    -c dcm2niix \
    -b \
    --overwrite

