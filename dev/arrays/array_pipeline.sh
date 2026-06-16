#!/bin/bash

######################### MAIN ###########################

# PIPELINE_ARRAY
# Description:
#   Canonical list of pipeline execution scripts (modules), defined as
#   full paths to shell scripts.
#
# Scope:
#   Consumed by pipeline.sh to submit SLURM jobs and construct execution
#   logic, including dependency chaining and parallelisation.
#
# Notes:
#   - Entries must be full paths (e.g. "${PIPELINE_DIR}/module.sh")
#   - Scripts must exist and be executable
#   - Order does NOT strictly define execution flow
#   - Order typically reflects logical processing sequence for readability
#   - Execution order and dependencies are determined explicitly within pipeline.sh
# - Each script is executed via bash in the same shell
# - No additional sbatch submission at module level in this pipeline

# Define array
PIPELINE_ARRAY=(
    "${PIPELINE_DIR}/1-bioproject-srr.sh" 
    "${PIPELINE_DIR}/2-srr-sra.sh"
)