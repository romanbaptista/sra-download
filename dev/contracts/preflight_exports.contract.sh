#!/bin/bash

######################### GUARDS ##########################

GUARD_ARRAY=(
    LOG_DIR
    CONTRACT_DIR
    ARRAY_DIR
)

######################### SOURCE ##########################

SOURCE_ARRAY=(
    "${ARRAY_DIR}/array_exports.sh"
)

######################### CHECKS ##########################

CHECK_ARRAY=(
    "array:EXPORT_ARRAY"
)