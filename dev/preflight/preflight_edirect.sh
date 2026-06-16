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
echo "Checking tool: ${TOOL_NAME}"
echo "Checking tool binary: ${TOOL_BINARY}"
if ! check_${TOOL_NAME}; then
    warning_message "Tool binary not found, installing to directory: ${TOOL_DIR}"
    install_${TOOL_NAME} || error_exit "Failed to install tool: ${TOOL_NAME}"
else
    echo "Tool binary found: ${TOOL_BINARY_PATH}"
fi

echo
echo "Creating environment file: ${TOOL_ENV}"
{
    echo "# Environment for ${TOOL_NAME}"
    echo "PATH=${TOOL_DIR}/bin:\$PATH"
    # Optional extensions (tool-specific)
    # echo "LD_LIBRARY_PATH=${TOOL_DIR}/lib:\$LD_LIBRARY_PATH"
    # echo "PYTHONPATH=${TOOL_DIR}/lib/python:\$PYTHONPATH"
} | write_env "${TOOL_ENV}" || error_exit "Failed to write environment file: ${TOOL_ENV}"
echo "Creation complete"

echo
echo "Reconstructing environment from file: ${TOOL_ENV}"
file_check_exists "${TOOL_ENV}" || error_exit "File not found: ${TOOL_ENV}" 
file_check_nonempty "${TOOL_ENV}" || error_exit "File is empty: ${TOOL_ENV}"
source "${TOOL_ENV}" || error_exit "Failed to source file: ${TOOL_ENV}"
echo "Environment complete"

echo
echo "Checking tool functionality: ${TOOL_NAME}"
tool_check_array TOOL_CHECK_ARRAY || error_exit "Tool failed to pass functionality checks: ${TOOL_NAME}"
echo "Functionality confirmed"

echo
echo "MAIN COMPLETE"
echo "----------------------"
success_message "SCRIPT COMPLETE: ${SCRIPT_NAME}.sh"