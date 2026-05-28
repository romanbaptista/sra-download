#!/bin/bash
set -euo pipefail

######################### GUARDS #########################

GUARD_ARRAY=(
    ARRAY_DIR
    LOG_DIR
    PIPELINE_DIR
    FUNCTIONS_DIR
)

for var in "${GUARD_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Variable is empty or not defined: ${var}"
done

######################### SETUP ###########################

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"

######################### SOURCE ##########################

source "${ARRAY_DIR}/array_pipeline.sh"    
source "${FUNCTIONS_DIR}/functions_base.sh"

######################### CHECKS #########################

array_check_nonempty PIPELINE_ARRAY || fail_message "PIPELINE_ARRAY is empty or not defined"

######################### MAIN ###########################

echo
echo "RUNNING ${SCRIPT_NAME} ..."

echo
echo "  Scripts to run:"

for script in "${PIPELINE_ARRAY[@]}"; do
    echo "      ${script}"
done

# Iterate through scripts
for script in "${PIPELINE_ARRAY[@]}"; do
    
    echo "  RUNNING ${script} ..."

    bash "${PIPELINE_DIR}/${script}" || fail_message "Failed to run script: ${script}"

    echo "  ${script} COMPLETE"

done

echo "${SCRIPT_NAME} COMPLETE"
