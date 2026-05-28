#!/bin/bash

######################### GUARDS #########################

GUARD_ARRAY=(
    ARRAY_DIR
)

for var in "${GUARD_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Variable is empty or not defined: ${var}"
done

######################### SETUP ##########################

# Define script name
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"

######################### SOURCE #########################

# Source array
source "${ARRAY_DIR}/array_variables.sh"

######################### CHECKS #########################

variable_check_nonempty VARIABLE_ARRAY || fail_message "VARIABLE_ARRAY is empty or is not set"
array_check_nonempty VARIABLE_ARRAY || fail_message "VARIABLE_ARRAY has no elements"

######################### MAIN ###########################

echo
echo "RUNNING ${SCRIPT_NAME} ..."
echo "  Checking for core user-defined variables..."

# Iterate over variables
for var in "${VARIABLE_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Variable is empty or not defined: ${var}"
done

echo "  User-defined variables confirmed"
echo "${SCRIPT_NAME} COMPLETE"