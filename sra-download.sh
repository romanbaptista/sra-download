#!/bin/bash
set -euo pipefail

######################## SETUP ###########################

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}" .sh)"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

######################## LOGS ############################

LOG_FILE="${ROOT_DIR}/logs/${SCRIPT_NAME}.log"
exec > >(tee -a "${LOG_FILE}") 2>&1

echo
echo "STARTING SCRIPT: ${SCRIPT_NAME}.sh"
echo "----------------------"

######################### MAIN ###########################

echo "SECTION - MAIN"

echo
echo "Checking for tool: tmux"
if ! command -v tmux >/dev/null 2>&1; then
    echo "ERROR: tmux is not installed or not in PATH"
    exit 1
fi
echo "Tool confirmed: tmux"

echo
echo "Checking for existing tmux session: ${SCRIPT_NAME}"
if tmux has-session -t "${SCRIPT_NAME}" 2>/dev/null; then
    echo "Existing session found: ${SCRIPT_NAME}"
    echo "Killing session: ${SCRIPT_NAME}"
    tmux kill-session -t "${SCRIPT_NAME}"
    echo "Session killed: ${SCRIPT_NAME}"
else
    echo "No existing session found"
fi

echo
echo "Launching new tmux session: ${SCRIPT_NAME}"
tmux new-session -d -s "${SCRIPT_NAME}" "cd ${ROOT_DIR} && bash ${SCRIPT_NAME}-run.sh"
echo "Session launched: ${SCRIPT_NAME}"
echo "Pipeline started inside session: ${SCRIPT_NAME}"
echo "- Attach with: tmux attach -t ${SCRIPT_NAME}"
echo "- Detach with: Ctrl + B then D"

echo
echo "MAIN COMPLETE"
echo "----------------------"
echo "SUCCESS - SCRIPT COMPLETE: ${SCRIPT_NAME}.sh"