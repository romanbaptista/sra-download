#!/bin/bash

######################### MAIN ###########################

# DIRECTORY_ARRAY
# Description:
#   Defines all pipeline-specific directories to be created at runtime.
#
# Scope:
#   Consumed by preflight_directories.sh for directory creation.
#
# Notes:
#   - Entries must be fully resolved paths
#   - Directories must NOT be created elsewhere
#   - Order is preserved but not semantically required

# Define array
DIRECTORY_ARRAY=(
    "${OUTPUT_DIR}/1-bioproject-srr"
    "${OUTPUT_DIR}/2-srr-sra"
)