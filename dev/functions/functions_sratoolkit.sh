#!/bin/bash

# functions_sratoolkit.sh
#
# Description:
#   Tool-specific functions for sratoolkit.
#
#   These functions implement:
#     - Minimal presence checks for the tool binary
#     - Tool-specific installation logic
#
#   The tool is installed under:
#     installs/sratoolkit/
#
#   After installation, the directory must conform to:
#     installs/sratoolkit/bin/<binary>
#
#   This file works alongside:
#     - utils_sratoolkit.sh   (tool metadata)
#     - functions_<type>.sh   (optional generic installers)
#     - preflight_sratoolkit.sh (orchestration)
#
# Notes:
#   - check_sratoolkit() must ONLY verify presence of the binary
#   - install_sratoolkit() may:
#        * call a generic installer (e.g. install_tarball, install_conda)
#        * OR implement fully tool-specific logic (e.g. downloader tools)
#   - Some tools (e.g. curl-based installers) cannot be generalised and
#     must be implemented entirely within install_sratoolkit()
#   - All tools MUST end with:
#        installs/sratoolkit/bin/<binary>
#
#   - Tool-specific restructuring (moving files, renaming directories,
#     relocating installations) must be handled here

# check_sratoolkit
#
# Description:
#   Checks for presence of the tool by verifying that
#   the canonical binary exists and is executable.
#
# Guarantees:
#   - Returns success if binary exists and is executable
#   - Does NOT validate functionality (handled later)
check_sratoolkit() {
    file_check_executable "${TOOL_BINARY_PATH}" || return 1
}

# install_sratoolkit
#
# Description:
#   Installs sratoolkit and prepares it for deterministic
#   runtime execution within the pipeline.
#
#   This function:
#
#     1. Cleans any pre-existing installation:
#          - removes installs/sratoolkit/ if present
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
#            installs/sratoolkit/bin/
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
#          - ensures installs/sratoolkit/bin exists
#          - ensures required binary is present
#
#     7. Defers environment exposure to preflight:
#          - .env file will later expose:
#                PATH=installs/sratoolkit/bin:$PATH
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
#        installs/sratoolkit/bin/<binary>
#
#   - The .env file under:
#        envs/sratoolkit.env
#     provides the sole runtime interface
install_sratoolkit() {

    # FUNCTION
    
    # CLEANUP
    directory_remove "${TOOL_DIR}" || error_return "Failed to cleanup existing install directory: ${TOOL_DIR}"

    # INSTALL
    install_tarball_tool "${TOOL_URL}" "${TOOL_DIR}" "${TOOL_TARBALL}" || error_return "Installation failed for tool: ${TOOL_NAME}"

    # RESTRUCTURE
    local extract_dir
    extract_dir="$(find "${TOOL_DIR}" -mindepth 1 -maxdepth 1 -type d | head -n 1)" || error_return "Failed to locate extracted tool directory in installs/"
    mv "${extract_dir}/bin" "${TOOL_DIR}/bin" || error_return "Failed to restructure tool directory: ${TOOL_DIR}"
    directory_remove "${extract_dir}" || error_return "Failed to cleanup default directory after restructuring: ${extract_dir}"

    # NORMALISE
    # Remove cluster-level PYTHONPATH
    unset PYTHONPATH 2>/dev/null || true
    
    # VALIDATE
    directory_check_exists "${TOOL_DIR}/bin" || error_return "Binary directory missing after install: ${TOOL_DIR}/bin"
    file_check_executable "${TOOL_BINARY_PATH}" || error_return "Binary not executable: ${TOOL_BINARY_PATH}"
}