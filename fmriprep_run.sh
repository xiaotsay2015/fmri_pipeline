#!/bin/sh

# This script is intended to run fmriprep, a functional magnetic resonance image preprocessing pipeline, using Singularity, a containerization tool.

#-----------------------------------------------------------
# Add some info to the job output at the start
#-----------------------------------------------------------
# Store the start time of the script. This will be used to calculate the total runtime of the script.
start=$(date +%s)

# Print the current date and time to the console.
date

# Print the subject that is being processed. This subject ID is passed as the second argument when running the script.
echo "Submitted subject: ${2}"

# ======================================================================
# FMRIPrep with Singularity
# ======================================================================

# Here we are using Singularity to run a specific version of fmriprep.
# The '-B' option is used to bind paths from the host system to the container. In this case, the project directory.
singularity run --cleanenv -B "${1}":/"${1}" \
    /imaging/local/software/singularity_images/fmriprep/fmriprep-21.0.1.simg \
    "${1}"/data/bids "${1}"/data/bids/derivatives/fmriprep \
    participant \
    --participant-label "${2}" \
    --work-dir "${1}"/work \
    --skip-bids-validation \
    -v \
    --fs-license-file "${1}"/data/bids/license.txt \
    --output-spaces MNI152NLin2009cAsym:res-2 T1w sbref \
    --write-graph \
    --ignore slicetiming \
    --fd-spike-threshold 0.9 \
    --nthreads 16 --omp-nthreads 8 \
    --stop-on-first-crash    

# Explanation of the fmriprep command:
# 1. "${1}"/data/bids: The input BIDS dataset directory.
# 2. "${1}"/data/bids/derivatives/fmriprep: The output directory for fmriprep results.
# 3. participant: Indicates that fmriprep should run at the participant level.
# 4. --participant-label "${2}": Specifies the participant label to process.
# 5. --work-dir "${1}"/work: Directory where fmriprep can store its working files.
# 6. --skip-bids-validation: Skips the BIDS validation step.
# 7. -v: Enables verbose output.
# 8. --fs-license-file "${1}"/data/bids/license.txt: Path to the FreeSurfer license file.
# 9. --output-spaces: Specifies the spaces to which the fmriprep outputs will be transformed.
# 10. --write-graph: Enables the writing of the workflow graph.
# 11. --ignore slicetiming: Ignores the slice timing information in the imaging data.
# 12. --fd-spike-threshold 0.9: Sets the framewise displacement spike threshold.
# 13. --nthreads 16 --omp-nthreads 8: Specifies the number of threads for parallel computing.
# 14. --stop-on-first-crash: If an error occurs, fmriprep will stop immediately.

#-----------------------------------------------------------
# Add some info to the job output at the end
#-----------------------------------------------------------
# Store the end time of
