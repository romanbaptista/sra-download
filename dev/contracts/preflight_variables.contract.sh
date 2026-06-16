#!/bin/bash

######################### GUARDS ##########################

GUARD_ARRAY=(
    LOG_DIR
    CONTRACT_DIR
    ARRAY_DIR
)

######################### SOURCE ##########################

SOURCE_ARRAY=(
    "${ARRAY_DIR}/array_variables.sh"
)

######################### CHECKS ##########################

CHECK_ARRAY=(
    "array:VARIABLE_ARRAY"
)