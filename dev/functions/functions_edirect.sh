#!/bin/bash

# functions_edirect.sh
#
# Description:
#   Tool-specific functions for edirect.
#
#   These functions implement:
#     - Minimal presence checks for the tool binary
#     - Tool-specific installation logic
#
#   The tool is installed under:
#     installs/edirect/
#
#   After installation, the directory must conform to:
#     installs/edirect/bin/<binary>
#
#   This file works alongside:
#     - utils_edirect.sh   (tool metadata)
#     - functions_<type>.sh   (optional generic installers)
#     - preflight_edirect.sh (orchestration)
#
# Notes:
#   - check_edirect() must ONLY verify presence of the binary
#   - install_edirect() may:
#        * call a generic installer (e.g. install_tarball, install_conda)
#        * OR implement fully tool-specific logic (e.g. downloader tools)
#   - Some tools (e.g. curl-based installers) cannot be generalised and
#     must be implemented entirely within install_edirect()
#   - All tools MUST end with:
#        installs/edirect/bin/<binary>
#
#   - Tool-specific restructuring (moving files, renaming directories,
#     relocating installations) must be handled here

# check_edirect
#
# Description:
#   Checks for presence of the tool by verifying that
#   the canonical binary exists and is executable.
#
# Guarantees:
#   - Returns success if binary exists and is executable
#   - Does NOT validate functionality (handled later)
check_edirect() {
    file_check_executable "${TOOL_BINARY_PATH}" || return 1
}


# install_edirect
#
# Description:
#   Installs edirect and prepares it for deterministic
#   runtime execution within the pipeline.
#
#   This function:
#
#     1. Cleans any pre-existing installation:
#          - removes installs/edirect/ if present
#          - ensures a fresh, deterministic install state
#          - avoids conflicts from partial or failed installations
#
#     2. Installs the tool using one of:
#          - install_tarball_tool       (tarball-based)
#          - install_conda_tool         (simple conda package)
#          - create_conda_env_from_yaml (complex environment)
#          - custom downloader logic    (tool-specific)
#
#     3. Extracts required executable(s) from the installation
#        into:
#            installs/edirect/bin/
#
#     4. Cleans up any temporary installation artifacts,
#        including:
#          - tarballs
#          - temporary conda environments
#
#     5. Normalises the runtime environment:
#          - unsets PYTHONPATH to avoid contamination from
#            cluster-level Python configurations
#          - this is particularly important for Python-based
#            tools (e.g. MultiQC)
#
#     6. Validates the final installation layout:
#          - ensures installs/edirect/bin exists
#          - ensures required binary is present
#
#     7. Defers environment exposure to preflight:
#          - .env file will later expose:
#                PATH=installs/edirect/bin:$PATH
#          - additional variables (e.g. LD_LIBRARY_PATH)
#            may be added if required for specific tools
#
# Notes:
#   - Conda environments are used ONLY for installation and
#     are deleted afterwards
#
#   - Runtime execution MUST NOT depend on:
#        * conda activation
#        * module loading
#        * external environment state
#
#   - All tools MUST conform to:
#        installs/edirect/bin/<binary>
#
#   - The .env file under:
#        envs/edirect.env
#     provides the sole runtime interface
install_edirect() {
    
    # FUNCTION
    
    # CLEANUP
    directory_remove "${TOOL_DIR}" || error_return "Failed to cleanup existing install directory: ${TOOL_DIR}"
    directory_remove "${HOME}/edirect" 2>/dev/null || true

    # INSTALL
    sh -c "$(curl -fsSL "${TOOL_URL}")" || error_return "Failed to run EDirect installation script: ${TOOL_URL}"

    # RESTRUCTURE
    local download_dir="${HOME}/edirect"
    directory_check_exists "${download_dir}" || error_return "Failed to find EDirect download directory: ${download_dir}"
    directory_create "${TOOL_DIR}" || error_return "Failed to create tool directory: ${TOOL_DIR}"
    directory_create "${TOOL_DIR}/bin" || error_return "Failed to create tool binary directory: ${TOOL_DIR}/bin"
    # Move all downloaded tool files to bin/
    find "${download_dir}" -maxdepth 1 -type f -exec mv {} "${TOOL_DIR}/bin/" \; || error_return "Failed to move edirect files into bin/ directory: ${TOOL_DIR}/bin/"
    directory_remove "${download_dir}" || error_return "Failed to cleanup EDirect download directory: ${download_dir}"
    
    # NORMALISE
    # Remove cluster-level PYTHONPATH
    unset PYTHONPATH 2>/dev/null || true
    
    # VALIDATE
    directory_check_exists "${TOOL_DIR}/bin" || error_return "Binary directory missing after install: ${TOOL_DIR}/bin"
    file_check_executable "${TOOL_BINARY_PATH}" || error_return "Binary not executable: ${TOOL_BINARY_PATH}"
}