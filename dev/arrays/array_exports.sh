#!/bin/bash

######################### MAIN ###########################

# EXPORT_ARRAY
# Description:
#   Canonical list of pipeline variables that form the execution ABI
#   (Application Binary Interface) across SLURM job boundaries.
#
# Scope:
#   Used in preflight to construct SBATCH_EXPORTS, which is passed to all
#   SLURM-submitted scripts (pipeline.sh and module scripts).
#
# Notes:
#   - Entries must be variable names (not values)
#   - All variables required in downstream SLURM jobs must be included
#   - Includes:
#       - base directory variables (from utils_paths.sh)
#       - pipeline directories (from DIRECTORY_ARRAY)
#       - user configuration variables
#       - runtime parameters
#   - Variables not included here will NOT be available in SLURM jobs

# Define array
EXPORT_ARRAY=(
    LOG_DIR
    FUNCTIONS_DIR
    CONTRACT_DIR
    PIPELINE_DIR
    OUTPUT_DIR
    ENV_DIR
    BIOPROJECT
)