#!/bin/bash

#=========================================================
# functions_conda.sh
#
# Description:
#   Generic conda helper functions used for installing tools.
#
#   Conda is treated strictly as an installation mechanism:
#     - Environments are created temporarily using -p
#     - Environments are NEVER activated
#     - Environments are deleted after use
#
#   These functions DO NOT:
#     - manage runtime environments
#     - move or copy binaries
#     - perform tool-specific logic
#
#   Tool-specific scripts (functions_<tool>.sh) must:
#     - extract required binaries
#     - place them into installs/<tool>/bin
#     - clean up temporary environments
#=========================================================

# initialise_conda
#
# Description:
#   Ensures conda is available in the current shell.
#   Loads module if required and sources conda.sh.
#
# Notes:
#   - Must be called before any conda commands
#   - Does NOT activate any environment
initialise_conda() {
    
    # FUNCTION
    if ! command -v conda >/dev/null 2>&1; then
        module load apps/anaconda-4.7.12.tcl || error_return "Failed to load conda module: apps/anaconda-4.7.12.tcl"
    fi

    local conda_base
    conda_base="$(conda info --base 2>/dev/null)" || error_return "Conda not available after loading module: apps/anaconda-4.7.12.tcl"
    source "${conda_base}/etc/profile.d/conda.sh" || error_return "Failed to initialise conda"
}

# create_conda_env
#
# Arguments:
#   $1 → env_path
#
# Description:
#   Creates a new empty conda environment at the given path.
#
# Notes:
#   - Uses path-based environments (-p)
#   - No packages installed here
create_conda_env() {
    
    # ARGUMENTS
    local env_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    initialise_conda
    conda create -y -p "${env_path}" || error_return "Failed to create conda environment: ${env_path}"
}

# create_conda_env_from_yaml
#
# Arguments:
#   $1 → env_path
#   $2 → yaml_file
#
# Description:
#   Creates a conda environment from a YAML specification.
#
# Notes:
#   - Used for complex pipelines / dependency stacks
#   - Environment remains temporary
create_conda_env_from_yaml() {
    
    # ARGUMENTS
    local env_path="${1-}"
    local yaml_path="${2-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    file_check_exists "${yaml_path}" || error_return "YAML file not found: ${yaml_path}"
    file_check_nonempty "${yaml_path}" || error_return "YAML file is empty: ${yaml_path}"
    initialise_conda
    conda env create -y -p "${env_path}" -f "${yaml_path}" || error_return "Failed to create conda environment from YAML"

}

# install_conda_package
#
# Arguments:
#   $1 → env_path
#   $2 → package
#
# Description:
#   Installs a package into an existing conda environment.
#
# Notes:
#   - No activation required (uses -p)
install_conda_package() {
    
    # ARGUMENTS
    local env_path="${1-}"
    local package="${2-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    initialise_conda
    conda install -y -p "${env_path}" "${package}" || error_return "Failed to install package: ${package}"
}

# install_conda_tool
#
# Arguments:
#   $1 → env_path
#   $2 → package
#
# Description:
#   Convenience wrapper:
#     - creates environment
#     - installs package
#
# Notes:
#   - Standard path for simple tools
install_conda_tool() {
    
    # ARGUMENTS
    local env_path="${1-}"
    local package="${2-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    initialise_conda
    create_conda_env "${env_path}" || error_return "Conda environment creation failed"
    install_conda_package "${env_path}" "${package}" || error_return "Conda package installation failed"
}