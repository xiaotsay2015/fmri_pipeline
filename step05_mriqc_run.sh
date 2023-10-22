#!/bin/bash

# Set the PROJECT_PATH variable to the root directory of the project
PROJECT_PATH=/group/plasticity/Projects/JT_Semantomotor/

# Use the 'singularity' command to run a containerized version of MRIQC
singularity run --cleanenv -B "$PROJECT_PATH":/"$PROJECT_PATH" \
    /imaging/local/software/singularity_images/mriqc/mriqc-22.0.1.simg \
    "$PROJECT_PATH"/data/bids "$PROJECT_PATH"/data/bids/derivatives/mriqc/ \
    --work-dir "$PROJECT_PATH"/data/work/mriqc/ \
    participant \
    --participant_label sub-01 sub-02 sub-03 sub-04 \
    --no-sub \
    --modalities T1w bold
