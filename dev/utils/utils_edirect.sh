#!/bin/bash

######################## TOOL METADATA ###################

TOOL_NAME="edirect"
TOOL_DIR="${INSTALLS_DIR}/${TOOL_NAME}"
TOOL_ENV="${ENVS_DIR}/${TOOL_NAME}.env"

######################## TOOL BINARY ####################

TOOL_BINARY="esearch"
TOOL_BINARY_PATH="${TOOL_DIR}/bin/${TOOL_BINARY}"

######################## DOWNLOAD SOURCE ################

TOOL_URL="https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh"

######################## TOOL VALIDATION ################

TOOL_CHECK_ARRAY=(
    "binary:esearch"
    "runtime:esearch"
    "subcommand:esearch:help"
)