#!/bin/bash

#=========================================================
# functions_tarball.sh
#
# Description:
#   Generic helper functions for installing tools from tarball
#   archives (e.g. .tar.gz).
#
#   These functions:
#     - download tool archives from a given URL
#     - extract archives into a specified directory
#     - perform basic cleanup of downloaded files
#
#   These functions DO NOT:
#     - perform any restructuring of extracted files
#     - move or rename tool directories
#     - validate tool binaries
#     - implement tool-specific logic
#
#   Tool-specific scripts (functions_<tool>.sh) must:
#     - reorganise extracted files if required
#     - ensure final structure:
#           installs/<tool>/bin/<binary>
#     - validate installation
#
#   This layer provides a generic, reusable tarball installer
#   that is intentionally minimal and non-opinionated.
#=========================================================

# download_tarball
#
# Arguments:
#   $1 → tool_url
#   $2 → tarball_path
#
# Description:
#   Downloads a tarball from the provided URL and writes it
#   to the specified local path.
#
# Notes:
#   - Uses wget for download
#   - Overwrites existing file if present
#   - Does NOT validate archive contents
download_tarball() {
    
    # ARGUMENTS
    local tool_url="${1-}"
    local tarball_path="${2-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    wget -q -O "${tarball_path}" "${tool_url}" || error_return "Failed to download tarball from URL: ${tool_url}"
}

# extract_tarball
#
# Arguments:
#   $1 → tarball_path
#   $2 → tool_dir
#
# Description:
#   Extracts the given tarball into the specified directory.
#
# Notes:
#   - Supports standard gzip-compressed tar archives
#   - Extraction occurs directly into tool_dir
#   - Does NOT perform directory flattening or restructuring
extract_tarball() {
    
    # ARGUMENTS
    local tarball_path="${1-}"
    local tool_dir="${2-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    tar -xzf "${tarball_path}" -C "${tool_dir}" || error_return "Failed to extract tarball: ${tarball_path}"
}

# install_tarball_tool
#
# Arguments:
#   $1 → tool_url
#   $2 → tool_dir
#   $3 → tool_tarball
#
# Description:
#   High-level wrapper that:
#     - creates the installation directory
#     - downloads the tarball
#     - extracts its contents
#     - cleans up the archive file
#
# Notes:
#   - This function performs a generic installation only
#   - It does NOT guarantee final binary layout
#   - Tool-specific restructuring MUST be performed in:
#         install_<tool>()
#
#   - After this function completes, tool contents will be
#     present under:
#         installs/<tool>/
#
#   - The caller is responsible for:
#         * moving binaries to installs/<tool>/bin
#         * validating installation
install_tarball_tool() {
    
    # ARGUMENTS
    local tool_url="${1-}"
    local tool_dir="${2-}"
    local tool_tarball="${3-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    mkdir -p "${tool_dir}" || error_return "Failed to create tool directory: ${tool_dir}"
    local tarball_path="${tool_dir}/${tool_tarball}"

    download_tarball "${tool_url}" "${tarball_path}" || error_return "Download failed"
    extract_tarball "${tarball_path}" "${tool_dir}" || error_return "Extraction failed"
    rm -f "${tarball_path}" || error_return "Failed to cleanup tarball: ${tarball_path}"
}