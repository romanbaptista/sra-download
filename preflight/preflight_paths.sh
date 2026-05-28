#!/bin/bash

######################### GUARDS #########################

GUARD_ARRAY=(
    ROOT_DIR
    UTILS_DIR
)

for var in "${GUARD_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Variable is empty or not defined: ${var}"
done

######################### SETUP ##########################

# Define script name
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"

######################### SOURCE #########################

# Source utils
source "${UTILS_DIR}/utils_paths.sh"

######################### CHECKS #########################

array_check_nonempty DIR_ARRAY || fail_message "DIR_ARRAY is empty or not defined"

######################### MAIN ###########################

echo
echo "RUNNING ${SCRIPT_NAME} ..."
echo "  Creating pipeline directories..."

# Define pipeline-specific directories
ENV_DIR="${ROOT_DIR}/env"
EDIRECT_OUTDIR="${OUTPUT_DIR}/1_edirect"
SRATOOLKIT_OUTDIR="${OUTPUT_DIR}/2_sratoolkit"

# Extend DIR_ARRAY (initialised in utils_paths.sh) with pipeline-specific directories
DIR_ARRAY+=(
    ENV_DIR
    EDIRECT_OUTDIR
    SRATOOLKIT_OUTDIR
)

# Create directories
for dir in "${DIR_ARRAY[@]}"; do
    directory_create "${!dir}" || fail_message "Failed to create directory: ${!dir}"
done

echo "  Directories created"
echo "${SCRIPT_NAME} COMPLETE"