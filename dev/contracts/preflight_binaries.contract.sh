#!/bin/bash

######################### GUARDS ##########################

GUARD_ARRAY=(
    LOG_DIR
    CONTRACT_DIR
    ARRAY_DIR
)

######################### SOURCE ##########################

SOURCE_ARRAY=(
    "${ARRAY_DIR}/array_binaries.sh"
)

######################### CHECKS ##########################

CHECK_ARRAY=(
    "array:BINARY_ARRAY"
)