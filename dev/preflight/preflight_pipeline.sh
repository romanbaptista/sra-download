#!/bin/bash
set -euo pipefail

######################## SETUP ###########################

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"

######################## LOGS ############################

LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

echo
echo "STARTING SCRIPT: ${SCRIPT_NAME}.sh"
echo "----------------------"

######################## CONTRACT ########################

echo "SECTION - CONTRACT"

CONTRACT_SCRIPT="${CONTRACT_DIR}/${SCRIPT_NAME}.contract.sh"
file_check_exists "${CONTRACT_SCRIPT}" || error_exit "File not found: ${CONTRACT_SCRIPT}"
file_check_nonempty "${CONTRACT_SCRIPT}" || error_exit "File is empty: ${CONTRACT_SCRIPT}"
source "${CONTRACT_SCRIPT}" || error_exit "Failed to source script: ${CONTRACT_SCRIPT}"

echo "CONTRACT COMPLETE"
echo "----------------------"

######################## GUARDS ##########################

echo "SECTION - GUARDS"

if [[ ${#GUARD_ARRAY[@]} -eq 0 ]]; then
    echo "No guards required for this script: ${SCRIPT_NAME}.sh"
else
    for entry in "${GUARD_ARRAY[@]}"; do
        variable_check_nonempty "${entry}" || error_exit "Variable is empty or not set: ${entry}"
    done
fi

echo "GUARDS COMPLETE"
echo "----------------------"

######################## SOURCE ##########################

echo "SECTION - SOURCE"

if [[ ${#SOURCE_ARRAY[@]} -eq 0 ]]; then
    echo "No sources required for this script: ${SCRIPT_NAME}.sh"
else
    for entry in "${SOURCE_ARRAY[@]}"; do
        file_check_exists "${entry}" || error_exit "Script not found: ${entry}"
        file_check_nonempty "${entry}" || error_exit "Script is empty: ${entry}"
        source "${entry}" || error_exit "Failed to source script: ${entry}"
    done
fi

echo "SOURCE COMPLETE"
echo "----------------------"

######################## CHECKS ##########################

echo "SECTION - CHECKS"

if [[ ${#CHECK_ARRAY[@]} -eq 0 ]]; then
    echo "No checks required for this script: ${SCRIPT_NAME}.sh"
else
    contract_check_array CHECK_ARRAY || error_exit "Failed to pass checks"
fi

echo "CHECKS COMPLETE"
echo "----------------------"

######################## MAIN ###########################

echo "SECTION - MAIN"

echo
echo "Validating pipeline scripts from array: PIPELINE_ARRAY"
for entry in "${PIPELINE_ARRAY[@]}"; do
    file_check_exists "${entry}" || error_exit "File not found: ${entry}"
    file_check_nonempty "${entry}" || error_exit "File is empty: ${entry}"
    file_enforce_executable "${entry}" || error_exit "Failed to enforce file as executable: ${entry}"
done
echo "Validation complete"

echo
echo "Checking for orchestrator: pipeline.sh"
PIPELINE_SCRIPT="${PIPELINE_DIR}/pipeline.sh"
file_check_exists "${PIPELINE_SCRIPT}" || error_exit "File not found: ${PIPELINE_SCRIPT}"
file_check_nonempty "${PIPELINE_SCRIPT}" || error_exit "File is empty: ${PIPELINE_SCRIPT}"
file_enforce_executable "${PIPELINE_SCRIPT}" || error_exit "Failed to enforce file as executable: ${PIPELINE_SCRIPT}"
echo "Orchestrator confirmed"

echo
echo "MAIN COMPLETE"
echo "----------------------"
success_message "SCRIPT COMPLETE: ${SCRIPT_NAME}.sh"