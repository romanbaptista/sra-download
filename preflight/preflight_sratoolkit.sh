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
TOOLNAME="sratoolkit"

######################### SOURCE #########################

source "${UTILS_DIR}/utils_${TOOLNAME}.sh"
source "${FUNCTIONS_DIR}/functions_${TOOLNAME}.sh"
source "${FUNCTIONS_DIR}/functions_pipeline.sh"

######################### CHECKS #########################

CHECK_ARRAY=(
    SRA_VERSION
    SRA_ARCHIVE
    SRA_URL
    SRA_DIR
    SRA_ENV
)

for var in "${CHECK_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Variable is empty or not defined: ${var}"
done

######################### MAIN ###########################

echo
echo "RUNNING ${SCRIPT_NAME} ..."
echo "  Checking for SRA Toolkit..."

# Check prefetch availability
if tool_check_binary prefetch; then
    tool_check_runtime prefetch || fail_message "prefetch found but not functional"
    tool_check_subcommand prefetch help || fail_message "prefetch help not functional"
    tool_check_binary vdb-config || fail_message "vdb-config binary missing"
    echo "  SRA Toolkit already available"
else
    echo "  SRA Toolkit not found, installing..."
    download_sratoolkit "${SRA_ARCHIVE}" "${SRA_URL}" || fail_message "Failed to download SRA Toolkit"
    extract_sratoolkit "${SRA_ARCHIVE}" "${SRA_DIR}" || fail_message "Failed to extract SRA Toolkit"
    tool_check_subcommand prefetch help || fail_message "prefetch not found after install"
    tool_check_runtime prefetch || fail_message "prefetch not working after install"
    tool_check_binary vdb-config || fail_message "vdb-config missing after install"
    echo "  SRA Toolkit installed"
fi

# Get prefetch location
PREFETCH_PATH="$(command -v prefetch)" || fail_message "Unable to resolve prefetch path"
# Get toolkit directory
SRA_DIR="$(cd "$(dirname "${PREFETCH_PATH}")/.." && pwd)"
# Validate SRA_DIR
variable_check_nonempty SRA_DIR || fail_message "Failed to derive toolkit directory"

echo "  SRA Toolkit confirmed"
echo "  Writing SRA Toolkit .env file..."

write_env "${SRA_DIR}" "${SRA_ENV}" || fail_message "Failed to write SRA Toolkit environment file"

echo "  Environment file written: ${SRA_ENV}"
echo "${SCRIPT_NAME} COMPLETE"