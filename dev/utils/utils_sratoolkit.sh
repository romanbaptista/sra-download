#!/bin/bash

######################## TOOL METADATA ###################

TOOL_NAME="sratoolkit"
TOOL_DIR="${INSTALLS_DIR}/${TOOL_NAME}"
TOOL_ENV="${ENVS_DIR}/${TOOL_NAME}.env"

######################## TOOL BINARY ####################

TOOL_BINARY="prefetch"
TOOL_BINARY_PATH="${TOOL_DIR}/bin/${TOOL_BINARY}"

######################## TARBALL SOURCE #################

TOOL_VERSION="2.10.9"
TOOL_TARBALL="sratoolkit.${TOOL_VERSION}-centos_linux64.tar.gz"
TOOL_URL="https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${TOOL_VERSION}/${TOOL_TARBALL}"

######################## TOOL VALIDATION ################

TOOL_CHECK_ARRAY=(
    "binary:prefetch"
    "runtime:prefetch"
    "subcommand:prefetch:help"
    "binary:vdb-config"
)