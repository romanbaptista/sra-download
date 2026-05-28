#!/bin/bash
set -euo pipefail

######################### GUARDS #########################

GUARD_ARRAY=(
    # Guard variables go here
)

for var in "${GUARD_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Variable is empty or not defined: ${var}"
done

######################### SETUP ##########################

# Define script name
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"
# Define toolname
TOOLNAME=""

######################### SOURCE #########################

source "${UTILS_DIR}/utils_${TOOLNAME}.sh"
source "${FUNCTIONS_DIR}/functions_${TOOLNAME}.sh"

######################### CHECKS #########################

# Validate any variables used downstream in this script, sourced from any of the scripts in the SOURCE section

######################### MAIN ###########################

echo
echo "  RUNNING ${SCRIPT_NAME} ..."
echo "  Doing something..."

...

echo "  Something done"
echo "  ${SCRIPT_NAME} COMPLETE"

