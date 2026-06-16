#!/bin/bash

######################### GUARDS ##########################

GUARD_ARRAY=(
    LOG_DIR
    CONTRACT_DIR
)

######################### SOURCE ##########################

SOURCE_ARRAY=(
    "${UTILS_DIR}/utils_edirect.sh"
    "${FUNCTIONS_DIR}/functions_edirect.sh"
    "${FUNCTIONS_DIR}/functions_conda.sh"
    "${FUNCTIONS_DIR}/functions_tarball.sh"
)

######################### CHECKS ##########################

CHECK_ARRAY=(
    "var:TOOL_NAME"
    "var:TOOL_BINARY"
    "var:TOOL_BINARY_PATH"
    "var:TOOL_DIR"
    "var:TOOL_ENV"
    "var:TOOL_URL"
)