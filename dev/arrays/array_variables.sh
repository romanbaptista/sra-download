#!/bin/bash

######################### MAIN ###########################

# VARIABLE_ARRAY
# Description:
#   Canonical list of required user-defined configuration variables.
#
# Scope:
#   Validated during preflight to ensure all required user inputs are
#   defined and non-empty before execution.
#
# Notes:
#   - Entries must correspond to variables defined in config.sh
#   - These variables represent user-provided pipeline inputs
#   - Does NOT include:
#       - directory variables (defined in utils_paths.sh)
#       - runtime variables generated during execution
#   - All entries are validated via variable_check_nonempty

# Define array
VARIABLE_ARRAY=(
    BIOPROJECT
)