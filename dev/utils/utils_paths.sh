#!/bin/bash

# Defines base directory variables derived from ROOT_DIR.

######################### PATHS ###########################

# Define root/ directories
LOG_DIR="${ROOT_DIR}/logs"
OUTPUT_DIR="${ROOT_DIR}/output"
DEV_DIR="${ROOT_DIR}/dev"

# Define dev/ directories
ARRAY_DIR="${DEV_DIR}/arrays"
CONTRACT_DIR="${DEV_DIR}/contracts"
ENVS_DIR="${DEV_DIR}/envs"
FUNCTIONS_DIR="${DEV_DIR}/functions"
INSTALLS_DIR="${DEV_DIR}/installs"
PIPELINE_DIR="${DEV_DIR}/pipeline"
PREFLIGHT_DIR="${DEV_DIR}/preflight"
UTILS_DIR="${DEV_DIR}/utils"

# Define PATHS_ARRAY for validation
PATHS_ARRAY=(
    LOG_DIR
    OUTPUT_DIR
    DEV_DIR
    ARRAY_DIR
    CONTRACT_DIR
    ENVS_DIR
    FUNCTIONS_DIR
    INSTALLS_DIR
    PIPELINE_DIR
    PREFLIGHT_DIR
    UTILS_DIR
)