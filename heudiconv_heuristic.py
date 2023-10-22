import os

# Define a function to create a BIDS key template and associated parameters.
def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')  # Ensure that a template string is provided
    return template, outtype, annotation_classes  # Return a tuple of template, file output type, and annotation classes

# Dictionary to specify options for populating the 'IntendedFor' field in field map JSON files in BIDS format.
POPULATE_INTENDED_FOR_OPTS = {
    'matching_parameters': ['ImagingVolume', 'Shims'],  # Parameters to match field maps with functional images
    'criterion': 'Closest'  # Criterion for matching: choose the closest field map in terms of acquisition time
}

# ----
# Define the main function to map DICOM series to BIDS file names
def infotodict(seqinfo):
    # BIDS keys
    anat = create_key('sub-{subject}/anat/sub-{subject}_acq-mprage_T1w')  # T1-weighted anatomical scan
    fmap_mag = create_key('sub-{subject}/fmap/sub-{subject}_magnitude')  # Magnitude image for field map
    fmap_phase = create_key('sub-{subject}/fmap/sub-{subject}_phasediff')  # Phase difference image for field map
    func_task = create_key('sub-{subject}/func/sub-{subject}_task-gesture_run-0{item:01d}_bold')  # Functional BOLD task
    sbref = create_key('sub-{subject}/func/sub-{subject}_task-gesture_run-0{item:01d}_sbref')  # Single-band reference image

    # Initialize an empty dictionary to store BIDS keys and associated series IDs
    info = {anat: [], fmap_mag: [], fmap_phase: [], func_task: [], sbref: []}

    # Loop through each series in seqinfo (a list of DICOM series information)
    for idx, s in enumerate(seqinfo):
        # Anatomical scan
        if (s.dim1 == 256) and ("MPRAGE" in s.protocol_name):
            info[anat].append(s.series_id)
        # Field map Magnitude (commented out)
        # if (s.dim3 == 66) and ('FieldMapping' in s.protocol_name):
            #info[fmap_mag].append(s.series_id)
        # Field map PhaseDiff (commented out)
        # if (s.dim3 == 33) and ('FieldMapping' in s.protocol_name):
            #info[fmap_phase].append(s.series_id)        
        # Functional BOLD
        if (s.dim1 == 106) and (s.dim4 > 100):
            info[func_task].append(s.series_id)
        # Single-band reference image
        if (s.dim1 == 106) and (s.dim4 < 3):
            info[sbref].append(s.series_id)

    return info
