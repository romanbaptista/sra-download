#!/bin/bash

######################### MAIN ###########################

# PREFLIGHT_ARRAY
# Description:
#   Canonical ordered list of preflight validation and setup scripts,
#   defined as full paths to shell scripts.
#
# Scope:
#   Consumed by preflight.sh to execute validation and setup stages
#   sequentially within the same shell context.
#
# Notes:
#   - Entries must be full paths (e.g. "${PREFLIGHT_DIR}/preflight_stage.sh")
#   - Scripts must include the .sh suffix
#   - Order is strictly enforced and defines execution sequence
#   - All scripts are sourced (not executed), and therefore share the same shell
#   - Used to modularise validation into discrete, ordered stages

# Define array
PREFLIGHT_ARRAY=(
    "${PREFLIGHT_DIR}/preflight_directories.sh"
    "${PREFLIGHT_DIR}/preflight_variables.sh"
    "${PREFLIGHT_DIR}/preflight_binaries.sh"
    "${PREFLIGHT_DIR}/preflight_exports.sh"
    "${PREFLIGHT_DIR}/preflight_pipeline.sh"
    "${PREFLIGHT_DIR}/preflight_edirect.sh"
    "${PREFLIGHT_DIR}/preflight_sratoolkit.sh"
)