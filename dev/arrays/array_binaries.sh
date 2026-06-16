#!/bin/bash

######################### MAIN ###########################

# BINARY_ARRAY
# Description:
#   Canonical list of required external system commands (CLI dependencies)
#   that must be available in the execution environment.
#
# Scope:
#   Validated during preflight to ensure required system tools exist before
#   pipeline execution.
#
# Notes:
#   - Entries must be command names (e.g. "sbatch", "grep", "awk")
#   - This array is for system-level dependencies only
#   - Tool-specific capability checks are handled separately (e.g. via functions)
#   - Does NOT include tools managed via envs/ (those are validated separately)

# Define array
BINARY_ARRAY=(
    bash
    tee
    wc
    tr
    xargs
    sed
    awk
    date
)