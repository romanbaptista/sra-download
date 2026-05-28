#!/bin/bash
set -euo pipefail

######################### SETUP ###########################

# Define pipeline root
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Define pipeline name
PIPELINE_NAME="$(basename "${ROOT_DIR}")"
# Define script name
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"

######################### SOURCE ##########################

source "${ROOT_DIR}/config.sh"                                  # User configuration
source "${ROOT_DIR}/functions/functions_base.sh"                # Base pipeline functions

######################### LOGS ############################

# Define log directory
LOG_DIR="${ROOT_DIR}/logs"
# Make log directory
mkdir -p "${LOG_DIR}"
# Define log file for this script
LOG_FILE="${LOG_DIR}/${SCRIPT_NAME}.log"
# Redirect stdout/stderr to terminal and log file
exec > >(tee -a "${LOG_FILE}") 2>&1

######################### PREFLIGHT #######################

echo
echo "PREFLIGHT for ${PIPELINE_NAME} ..."

# Run preflight.sh orchestrator
source "${ROOT_DIR}/preflight/preflight.sh"

echo
echo "PREFLIGHT for ${PIPELINE_NAME} COMPLETE"

######################### TMUX ############################

# Define tmux session name
TMUX_SESSION_NAME="sra-download"

# Define TMUX variables
TMUX_ARRAY=(
    ROOT_DIR
    ARRAY_DIR
    FUNCTIONS_DIR
    PIPELINE_DIR
    PREFLIGHT_DIR
    UTILS_DIR
    LOG_DIR
)

# Initialise TMUX_EXPORTS
TMUX_EXPORTS=""

# Validate all variables
for var in "${TMUX_ARRAY[@]}"; do
    variable_check_nonempty "${var}" || fail_message "TMUX export variable not set: ${var}"
    TMUX_EXPORTS+="${var}='${!var}' "
done

######################### MAIN ############################

echo
echo "RUNNING ${SCRIPT_NAME} ..."

echo
echo "  User configuration:"
echo "      BioProject:         ${BIOPROJECT}"

# tmux session
if tmux has-session -t "${TMUX_SESSION_NAME}" 2>/dev/null; then
    echo "  Existing tmux session detected: ${TMUX_SESSION_NAME}"
    echo "  Terminating existing session..."
    tmux kill-session -t "${TMUX_SESSION_NAME}"
    sleep 1
    echo "  Session terminated"
fi

echo "  Creating new tmux session..."
echo "  Submitting pipeline.sh to tmux session..."

tmux new-session -d -s "${TMUX_SESSION_NAME}" "${TMUX_EXPORTS} bash \"${PIPELINE_DIR}/pipeline.sh\""

echo "  pipeline.sh submitted to tmux session: ${TMUX_SESSION_NAME}"
echo
echo "  To monitor progress, use:"
echo "  'tmux attach -t ${TMUX_SESSION_NAME}'"
echo
echo "  To detach again, without stopping jobs:"
echo "  Press Ctrl+b then d"
echo
echo "  To kill session, use:"
echo "  'tmux kill-session -t ${TMUX_SESSION_NAME}'"

echo "${SCRIPT_NAME} COMPLETE"