#!/bin/bash
set -euo pipefail

######################## SETUP ###########################

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"

######################## LOGS ############################

LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

echo
echo "STARTING SCRIPT: ${SCRIPT_NAME}.sh"
echo "----------------------"

######################## FUNCTIONS #######################

echo "SECTION - FUNCTIONS"

# Bootstrap: load base functions in a new shell environment
if [[ -z "${FUNCTIONS_DIR:-}" ]]; then
    echo "ERROR - FUNCTIONS_DIR is not set"
    echo "EXITING..."
    exit 1
fi

if [[ ! -f "${FUNCTIONS_DIR}/functions_base.sh" ]]; then
    echo "ERROR - functions_base.sh not found: ${FUNCTIONS_DIR}"
    echo "EXITING..."
    exit 1
fi

source "${FUNCTIONS_DIR}/functions_base.sh" || {
    echo "ERROR - Failed to source functions_base.sh"
    echo "EXITING..."
    exit 1
}

echo "FUNCTIONS LOADED"
echo "----------------------"

######################## CONTRACT ########################

echo "SECTION - CONTRACT"

CONTRACT_SCRIPT="${CONTRACT_DIR}/${SCRIPT_NAME}.contract.sh"
file_check_exists "${CONTRACT_SCRIPT}" || error_exit "File not found: ${CONTRACT_SCRIPT}"
file_check_nonempty "${CONTRACT_SCRIPT}" || error_exit "File is empty: ${CONTRACT_SCRIPT}"
source "${CONTRACT_SCRIPT}" || error_exit "Failed to source script: ${CONTRACT_SCRIPT}"

echo "CONTRACT COMPLETE"
echo "----------------------"

######################## GUARDS ##########################

echo "SECTION - GUARDS"

if [[ ${#GUARD_ARRAY[@]} -eq 0 ]]; then
    echo "No guards required for this script: ${SCRIPT_NAME}.sh"
else
    for entry in "${GUARD_ARRAY[@]}"; do
        variable_check_nonempty "${entry}" || error_exit "Variable is empty or not set: ${entry}"
    done
fi

echo "GUARDS COMPLETE"
echo "----------------------"

######################## SOURCE ##########################

echo "SECTION - SOURCE"

if [[ ${#SOURCE_ARRAY[@]} -eq 0 ]]; then
    echo "No sources required for this script: ${SCRIPT_NAME}.sh"
else
    for entry in "${SOURCE_ARRAY[@]}"; do
        file_check_exists "${entry}" || error_exit "Script not found: ${entry}"
        file_check_nonempty "${entry}" || error_exit "Script is empty: ${entry}"
        source "${entry}" || error_exit "Failed to source script: ${entry}"
    done
fi

echo "SOURCE COMPLETE"
echo "----------------------"

######################## CHECKS ##########################

echo "SECTION - CHECKS"

if [[ ${#CHECK_ARRAY[@]} -eq 0 ]]; then
    echo "No checks required for this script: ${SCRIPT_NAME}.sh"
else
    contract_check_array CHECK_ARRAY || error_exit "Failed to pass checks"
fi

echo "CHECKS COMPLETE"
echo "----------------------"

######################## ENVS ############################

echo "SECTION - ENVS"

if [[ ${#ENV_ARRAY[@]} -eq 0 ]]; then
    echo "No .env files required for this script: ${SCRIPT_NAME}.sh"
else
    for entry in "${ENV_ARRAY[@]}"; do
        file_check_exists "${entry}" || error_exit "File not found: ${entry}"
        file_check_nonempty "${entry}" || error_exit "File is empty: ${entry}"
        source "${entry}" || error_exit "Failed to source environment file: ${entry}"
    done
fi

echo "ENVS COMPLETE"
echo "----------------------"

######################## MAIN ############################

echo "SECTION - MAIN"

echo
echo "Info:"
echo "- Output directory:           ${SCRIPT_OUTDIR}"
echo "- Accession file:             ${ACCESSION_FILE}"
SRR_COUNT=$(wc -l < "${ACCESSION_FILE}" | tr -d '[:space:]')
echo "- Number of accessions:       ${SRR_COUNT}"

echo
echo "Downloading SRA files"
SRA_COUNT=0

# Iterate over accessions
while read -r SRR; do

    # Format SRR ID (remove CR, leading/trailing whitespace)
    SRR="$(echo "${SRR}" | tr -d '\r' | xargs)"

    # Skip if empty
    [[ -z "${SRR}" ]] && continue

    # Iterate count
    SRA_COUNT=$((SRA_COUNT+1))

    echo "[${SRA_COUNT} / ${SRR_COUNT}] $(date '+%Y-%m-%d %H:%M:%S') - Processing ${SRR}"

    # Accession directory path
    ACCESSION_DIR="${SCRIPT_OUTDIR}/${SRR}" 
    directory_create "${ACCESSION_DIR}" || error_exit "Failed to create directory: ${ACCESSION_DIR}"

    # Skip if already downloaded
    file_check_exists "${ACCESSION_DIR}/${SRR}.sra" && {
        echo "${SRR} already downloaded; skipping..."
        continue
    }

    # Localise SRA config
    VDB_CONFIG="${ACCESSION_DIR}/.vdb-config" \
    vdb-config --set /repository/user/main/public/root="${ACCESSION_DIR}"

    # Download SRA file
    prefetch \
        --transport https \
        --output-directory "${ACCESSION_DIR}" "${SRR}" \
        || error_exit "prefetch failed for ${SRR}"

done < "${ACCESSION_FILE}"
echo "SRA files downloaded"

echo
echo "MAIN COMPLETE"
echo "----------------------"
success_message "SCRIPT COMPLETE: ${SCRIPT_NAME}.sh"