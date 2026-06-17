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
echo "- Output directory:       ${SCRIPT_OUTDIR}"
echo "- BioProject ID:          ${BIOPROJECT}"

echo
echo "Getting UIDs"
esearch -db bioproject -query "${BIOPROJECT}" \
    | elink -target biosample \
    | efetch -format uid \
    > "${UID_FILE}"

UID_COUNT=$(wc -l < "${UID_FILE}" | tr -d '[:space:]')

if [[ "${UID_COUNT}" -eq 0 ]]; then
    error_exit "No BioSample UIDs found for BioProject ID: ${BIOPROJECT}"
fi
echo "UIDs found: ${UID_COUNT}"
echo "UIDs saved to file: ${UID_FILE}"

echo
echo "Getting XML metadata"
efetch -db biosample -format docsum \
    < "${UID_FILE}" \
    > "${METADATA_FILE}"
echo "XML metadata saved to file: ${METADATA_FILE}"

echo
echo "Getting SAMN accession IDs"
cat "${METADATA_FILE}" \
  | xtract -pattern DocumentSummary -element Accession \
  > "${SAMN_FILE}"

SAMN_COUNT=$(wc -l < "${SAMN_FILE}" | tr -d '[:space:]')
echo "SAMN IDs found: ${SAMN_COUNT}"
echo "SAMN accession IDs saved to file: ${SAMN_FILE}"

echo
echo "Getting SRR accessions"
esearch -db bioproject -query "${BIOPROJECT}" \
 | elink -target sra \
 | efetch -format runinfo \
 | awk -F',' 'NR>1 {print $1}' \
 > "${SRR_FILE}"

sed -i 's/\r$//' "${SRR_FILE}"
file_check_exists "${SRR_FILE}" || error_exit "File not found: ${SRR_FILE}"
file_check_nonempty "${SRR_FILE}" || error_exit "File is empty: ${SRR_FILE}"
SRR_COUNT=$(wc -l < "${SRR_FILE}" | tr -d '[:space:]')
echo "SRR accessions found: ${SRR_COUNT}"
echo "SRR accessions saved to file: ${SRR_FILE}"

echo
echo "MAIN COMPLETE"
echo "----------------------"
success_message "SCRIPT COMPLETE: ${SCRIPT_NAME}.sh"