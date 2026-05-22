#!/bin/bash
set -euo pipefail

######################### GUARDS ##########################

: "${PREFLIGHT_DIR:?PREFLIGHT_DIR not set (check PATHS section in run_pipeline.sh)}"
: "${PREFLIGHT_ARRAY:?PREFLIGHT_ARRAY not set (check arrays.sh)}"
: "${UTILS_DIR:?UTILS_DIR not set (check PATHS section in run_pipeline.sh)}"

######################### SETUP ##########################

# Define script name
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}" .sh)

######################### MAIN ############################

echo "  RUNNING ${SCRIPT_NAME} ..."

# Iterate through preflight checks
for script in "${PREFLIGHT_ARRAY[@]}"; do
    check_file "${PREFLIGHT_DIR}/${script}" || fail "  Please ensure that preflight script exists: ${script}"
    check_file_data "${PREFLIGHT_DIR}/${script}" || fail "  Please ensure that preflight script contains data: ${script}"
    source "${PREFLIGHT_DIR}/${script}"
done

echo
echo "  ${SCRIPT_NAME} COMPLETE"