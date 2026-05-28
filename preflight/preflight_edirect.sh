#!/bin/bash
set -euo pipefail

######################### GUARDS #########################

GUARD_ARRAY=(
    UTILS_DIR
    FUNCTIONS_DIR
    ENV_DIR
)

for var in "${GUARD_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Variable is empty or not defined: ${var}"
done

######################### SETUP ##########################

# Define script name
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"
# Define toolname
TOOLNAME="edirect"

######################### SOURCE #########################

source "${UTILS_DIR}/utils_${TOOLNAME}.sh"
source "${FUNCTIONS_DIR}/functions_${TOOLNAME}.sh"
source "${FUNCTIONS_DIR}/functions_pipeline.sh"

######################### CHECKS #########################

CHECK_ARRAY=(
    EDIRECT_URL
    EDIRECT_ENV
)

for var in "${CHECK_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Variable is empty or not defined: ${var}"
done

######################### MAIN ###########################

echo
echo "RUNNING ${SCRIPT_NAME} ..."
echo "  Checking for EDirect..."

# Check for esearch availability
if tool_check_subcommand esearch help && tool_check_runtime esearch; then
    echo "  EDirect already available"
else
    echo "  EDirect not found, installing..."
    download_edirect "${EDIRECT_URL}" || fail_message "EDirect installation failed"
    tool_check_subcommand esearch help || fail_message "esearch command not found after install"
    tool_check_runtime esearch || fail_message "esearch not functional after install"
    echo "  EDirect installed"
fi

# Get esearch location
ESEARCH_PATH="$(command -v esearch)" || fail_message "Unable to resolve esearch path"
# Get EDirect directory path
EDIRECT_DIR="$(cd "$(dirname "${ESEARCH_PATH}")" && pwd)"
# Validate EDIRECT_DIR
variable_check_nonempty EDIRECT_DIR || fail_message "Failed to derive EDirect directory"

echo "  EDirect confirmed"
echo "  Writing EDirect .env file..."

write_env "${EDIRECT_DIR}" "${EDIRECT_ENV}" || fail_message "Failed to write EDirect environment file"

echo "  Environment file written: ${EDIRECT_ENV}"
echo "${SCRIPT_NAME} COMPLETE"