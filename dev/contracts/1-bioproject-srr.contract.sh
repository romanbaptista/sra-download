#!/bin/bash

######################### GUARDS ##########################

GUARD_ARRAY=(
    BIOPROJECT
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
    "${ENV_DIR}/edirect.env"
)

######################### INPUT ###########################

# Any input directories/files defined here

######################### OUTPUT ##########################

CONTRACT_NAME="$(basename "${BASH_SOURCE[0]}" .contract.sh)"
SCRIPT_OUTDIR="${OUTPUT_DIR}/${CONTRACT_NAME}"
UID_FILE="${SCRIPT_OUTDIR}/biosample_uids.txt"
METADATA_FILE="${SCRIPT_OUTDIR}/biosample_docsum.xml"
SAMN_FILE="${SCRIPT_OUTDIR}/biosample_samn_accessions.txt"
SRR_FILE="${SCRIPT_OUTDIR}/biosample_srr_accessions.txt"

######################### CHECKS ##########################

CHECK_ARRAY=(
    "array:ENV_ARRAY"
)