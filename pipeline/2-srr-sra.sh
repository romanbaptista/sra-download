#!/bin/bash
set -euo pipefail

######################### GUARDS #########################

GUARD_ARRAY=(
    FUNCTIONS_DIR
    OUTPUT_DIR
    SRATOOLKIT_OUTDIR
)

for var in "${GUARD_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Guard check failed: ${var}"
done

######################### SETUP ##########################

# Define script name
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"

######################### SOURCE #########################

source "${FUNCTIONS_DIR}/functions_base.sh"

######################### INPUT ##########################

ACCESSION_FILE="${OUTPUT_DIR}/1-bioproject-srr/biosample_srr_accessions.txt"

######################### CHECKS #########################

file_check_exists "${ACCESSION_FILE}" || fail_message "Accession file not found: ${ACCESSION_FILE}"
file_check_nonempty "${ACCESSION_FILE}" || fail_message "Accession file is empty: ${ACCESSION_FILE}"
SRR_COUNT=$(wc -l < "${ACCESSION_FILE}" | tr -d '[:space:]')

######################### MAIN ###########################

echo
echo "RUNNING ${SCRIPT_NAME} ..."

echo "  Info:"
echo "    Accession file:           ${ACCESSION_FILE}"
echo "    Number of accessions:     ${SRR_COUNT}"
echo "    Output directory:         ${SRATOOLKIT_OUTDIR}"

echo
echo "  Downloading SRA files..."

# Initialise count
SRA_COUNT=0

# Iterate over accessions
while read -r SRR; do

    # Format SRR ID (remove CR, leading/trailing whitespace)
    SRR="$(echo "${SRR}" | tr -d '\r' | xargs)"

    # Skip if empty
    [[ -z "${SRR}" ]] && continue

    # Iterate count
    SRA_COUNT=$((SRA_COUNT+1))

    echo "  [${SRA_COUNT} / ${SRR_COUNT}] $(date '+%Y-%m-%d %H:%M:%S') - Processing ${SRR}"

    # Accession directory path
    ACCESSION_DIR="${SRATOOLKIT_OUTDIR}/${SRR}" 
    directory_create "${ACCESSION_DIR}" || fail_message "Failed to create directory: ${ACCESSION_DIR}"

    # Skip if already downloaded
    file_check_exists "${ACCESSION_DIR}/${SRR}.sra" && {
        echo "  ${SRR} already downloaded; skipping..."
        continue
    }

    # Localise SRA config
    VDB_CONFIG="${ACCESSION_DIR}/.vdb-config" \
    vdb-config --set /repository/user/main/public/root="${ACCESSION_DIR}"

    # Download SRA file
    prefetch \
        --transport https \
        --output-directory "${ACCESSION_DIR}" "${SRR}" \
        || fail_message "prefetch failed for ${SRR}"

done < "${ACCESSION_FILE}"

echo "  ${SRA_COUNT} SRA files downloaded"
echo "${SCRIPT_NAME} COMPLETE"