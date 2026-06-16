#!/bin/bash
set -euo pipefail

######################## SETUP ###########################

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINE_NAME="$(basename "${ROOT_DIR}")"

if [[ -z "${TMUX:-}" ]]; then
    echo "ERROR: This script must be run via ${PIPELINE_NAME}.sh"
    exit 1
fi

######################## LOGS ############################

LOG_FILE="${ROOT_DIR}/logs/${SCRIPT_NAME}.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

echo
echo "STARTING SCRIPT: ${SCRIPT_NAME}.sh"
echo "----------------------"

######################## FUNCTIONS #######################

echo "SECTION - FUNCTIONS"

source "${ROOT_DIR}/dev/functions/functions_base.sh" || {
    echo "ERROR - Failed to source script: functions_base.sh"
    echo "EXITING..."
    exit 1
}

echo "FUNCTIONS LOADED"
echo "----------------------"

######################## CONFIG ##########################

echo "SECTION - CONFIG"

CONFIG_SCRIPT="${ROOT_DIR}/config.sh"
file_check_exists "${CONFIG_SCRIPT}" || error_exit "File not found: ${CONFIG_SCRIPT}"
file_check_nonempty "${CONFIG_SCRIPT}" || error_exit "File is empty: ${CONFIG_SCRIPT}"
source "${CONFIG_SCRIPT}" || error_exit "Failed to source file: ${CONFIG_SCRIPT}"

echo "CONFIG LOADED"
echo "----------------------"

######################## PATHS ###########################

echo "SECTION - PATHS"

PATHS_SCRIPT="${ROOT_DIR}/dev/utils/utils_paths.sh"
source "${PATHS_SCRIPT}" || error_exit "Failed to source script: ${PATHS_SCRIPT}"

for entry in "${PATHS_ARRAY[@]}"; do
    variable_check_nonempty "${entry}" || error_exit "Variable empty or not set: ${entry}"
    directory_check_exists "${!entry}" || error_exit "Directory not found: ${!entry}"
done

echo "PATHS LOADED"
echo "----------------------"

######################### PREFLIGHT ######################

echo "SECTION - PREFLIGHT"

PREFLIGHT_SCRIPT="${PREFLIGHT_DIR}/preflight.sh"
source "${PREFLIGHT_SCRIPT}" || error_exit "Failed to source file: ${PREFLIGHT_SCRIPT}"

echo "PREFLIGHT COMPLETE"
echo "----------------------"

######################### MAIN ###########################

echo "SECTION - MAIN"

echo
echo "Info:"
echo "- BioProject ID:      ${BIOPROJECT}"

echo
echo "Submitting pipeline.sh"
PIPELINE_SCRIPT="${PIPELINE_DIR}/pipeline.sh"

RUN_ID=$(
    sbatch \
        --parsable \
        --job-name="${PIPELINE_NAME}" \
        --export="${SBATCH_EXPORTS}" \
        --output="${LOG_DIR}/pipeline.%j.log" \
        "${PIPELINE_SCRIPT}"
) || error_exit "Failed to submit script: ${PIPELINE_SCRIPT}"
echo "Submission complete"
echo "Run ID: ${RUN_ID}"

echo
echo "MAIN COMPLETE"
echo "----------------------"
success_message "SCRIPT COMPLETE: ${SCRIPT_NAME}.sh"