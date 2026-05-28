#!/bin/bash
set -euo pipefail

######################### GUARDS #########################

GUARD_ARRAY=(
    BIOPROJECT
    FUNCTIONS_DIR
    EDIRECT_OUTDIR
)

for var in "${GUARD_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "Guard check failed: ${var}"
done

######################### SETUP ##########################

# Define script name
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"

######################### SOURCE #########################

source "${FUNCTIONS_DIR}/functions_base.sh"

######################### OUTPUT #########################

UID_FILE="${EDIRECT_OUTDIR}/biosample_uids.txt"
METADATA_FILE="${EDIRECT_OUTDIR}/biosample_docsum.xml"
SAMN_FILE="${EDIRECT_OUTDIR}/biosample_samn_accessions.txt"
SRR_FILE="${EDIRECT_OUTDIR}/biosample_srr_accessions.txt"

######################### MAIN ###########################

echo
echo "RUNNING ${SCRIPT_NAME} ..."

echo
echo "  Info:"
echo "    Output directory:     ${EDIRECT_OUTDIR}"

echo
echo "  Getting UIDs..."

# Get UIDs
esearch -db bioproject -query "${BIOPROJECT}" \
    | elink -target biosample \
    | efetch -format uid \
    > "${UID_FILE}"

# Get number of UIDs
UID_COUNT=$(wc -l < "${UID_FILE}" | tr -d '[:space:]')

# Check UIDs
if [[ "${UID_COUNT}" -eq 0 ]]; then
    fail_message "No BioSample UIDs found for BioProject ID: ${BIOPROJECT}"
fi

echo "  ${UID_COUNT} UIDs saved to file: ${UID_FILE}"
echo "  Getting XML metadata..."

efetch -db biosample -format docsum \
    < "${UID_FILE}" \
    > "${METADATA_FILE}"

echo "  XML metadata saved to file: ${METADATA_FILE}"
echo "  Getting SAMN accession IDs..."

cat "${METADATA_FILE}" \
  | xtract -pattern DocumentSummary -element Accession \
  > "${SAMN_FILE}"

# Get number of SAMN IDs
SAMN_COUNT=$(wc -l < "${SAMN_FILE}" | tr -d '[:space:]')

echo "  ${SAMN_COUNT} SAMN accessions saved to file: ${SAMN_FILE}"
echo "  Getting SRR accessions"

# Get SRR accessions
esearch -db bioproject -query "${BIOPROJECT}" \
 | elink -target sra \
 | efetch -format runinfo \
 | awk -F',' 'NR>1 {print $1}' \
 > "${SRR_FILE}"

# Format line endings
sed -i 's/\r$//' "${SRR_FILE}"

# Check SRR file
file_check_exists "${SRR_FILE}" || fail_message "Accession file not found: ${SRR_FILE}"
file_check_nonempty "${SRR_FILE}" || fail_message "Accession file is empty: ${SRR_FILE}"

# Get number of SRR accessions
SRR_COUNT=$(wc -l < "${SRR_FILE}" | tr -d '[:space:]')

echo "  ${SRR_COUNT} accessions saved to file: ${SRR_FILE}"
echo "${SCRIPT_NAME} COMPLETE"