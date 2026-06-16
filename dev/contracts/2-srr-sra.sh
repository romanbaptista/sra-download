#!/bin/bash

######################### GUARDS ##########################

GUARD_ARRAY=(
    FUNCTIONS_DIR
    LOG_DIR
    CONTRACT_DIR
    OUTPUT_DIR
    ENV_DIR
)

######################### SOURCE ##########################

SOURCE_ARRAY=(
    # All scripts to be sourced by script
)

######################### ENVS ############################

ENV_ARRAY=(
    "${ENV_DIR}/sratoolkit.env"
)

######################### INPUT ###########################

ACCESSION_FILE="${OUTPUT_DIR}/1-bioproject-srr/biosample_srr_accessions.txt"

######################### OUTPUT ##########################

CONTRACT_NAME="$(basename "${BASH_SOURCE[0]}" .contract.sh)"
SCRIPT_OUTDIR="${OUTPUT_DIR}/${CONTRACT_NAME}"

######################### CHECKS ##########################

CHECK_ARRAY=(
    "array:ENV_ARRAY"
    "file:ACCESSION_FILE"
)