#!/bin/bash

#=========================================================
# functions_base.sh
# Description: Core pipeline runtime functions (validation, logging, IO, tools
#
# function_name
# Description: What it does (1 sentence)
# Usage: function_name <arg1> [arg2...]
# Notes: (optional, only if needed)
# Example:
#   example usage here
#=========================================================

######################### PRIMITIVES #####################

# argument_check_nonempty
# Description: Fails if argument is empty or whitespace-only
# Usage: argument_check_nonempty <value>
# Returns: 0 if valid, 2 if empty
argument_check_nonempty() {
    
    # ARGUMENTS
    local argument="${1-}"

    # FUNCTION
    if [[ -z "${argument//[[:space:]]/}" ]]; then
        echo "ERROR: ${FUNCNAME[1]} - Missing required argument" >&2
        return 2
    fi
}

######################### LOGGING ########################

# success_message
# Description: Print success message to stderr
# Usage: success_message <message>
success_message() {
    
    # ARGUMENTS
    local message="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    echo "SUCCESS - ${message}" >&2
}

# warning_message
# Description: Print warning message to stderr
# Usage: warning_message <message>
warning_message() {
    
    # ARGUMENTS
    local message="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    echo "WARNING - ${message}" >&2
}

# error_message
# Description: Print formatted error message to stderr
# Usage: error_message <message>
error_message() {
    
    # ARGUMENTS
    local message="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    echo "ERROR - ${message}" >&2
}

# error_return
# Description: Print error message with caller context and return non-zero
# Usage: error_return <message>
# Returns: 1
error_return() {
    
    # ARGUMENTS
    local message="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    local caller="${FUNCNAME[1]}"

    error_message "${caller} - ${message}"
    return 1
}

# error_exit
# Description: Print error message and terminate script execution
# Usage: error_exit <message>
# Exits: 1
error_exit() {
    
    # ARGUMENTS
    local message="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    error_message "${message}"
    echo "EXITING..." >&2
    exit 1
}

######################### VALIDATION #####################

# variable_check_nonempty
# Description: Check that a variable (by name) is non-empty
# Usage: variable_check_nonempty <variable_name>
# Example:
#   var="hello"
#   variable_check_nonempty var
variable_check_nonempty() {
    
    # ARGUMENTS
    local variable_name="${1-}"
    local variable_value="${!variable_name-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    [[ -n "${variable_value//[[:space:]]/}" ]]
}

# array_check_nonempty
# Description: Check that an array (by name) has at least one element
# Usage: array_check_nonempty <array_name>
# Example:
#   arr=("a" "b")
#   array_check_nonempty arr
array_check_nonempty() {
    
    # ARGUMENTS
    local array_name="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    local -n entries="${array_name}"
    
    [[ "${#entries[@]}" -gt 0 ]]
}

# directory_check_exists
# Description: Check that a directory exists
# Usage: directory_check_exists <directory_path>
directory_check_exists() {
    
    # ARGUMENTS
    local directory_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    [[ -d "${directory_path}" ]]
}

# directory_check_nonempty
# Description: Check that a directory contains at least one file
# Usage: directory_check_nonempty <directory_path>
directory_check_nonempty() {
    
    # ARGUMENTS
    local directory_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    find "${directory_path}" -mindepth 1 -print -quit 2>/dev/null | grep -q .
}

# directory_check_filetype
# Description: Check if directory contains files of given type
# Usage: directory_check_filetype <directory_path> "<glob>"
# Example:
#   directory_check_filetype data "*.sra"
directory_check_filetype() {
    
    # ARGUMENTS
    local directory_path="${1-}"
    local filetype_ext="${2-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    find "${directory_path}" -type f -name "${filetype_ext}" -print -quit 2>/dev/null | grep -q .
}

# file_check_exists
# Description: Check that file exists
# Usage: file_check_exists <file_path>
file_check_exists() {
    
    # ARGUMENTS
    local file_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    [[ -f "${file_path}" ]]
}

# file_check_nonempty
# Description: Check that file exists and is non-empty
# Usage: file_check_nonempty <file_path>
file_check_nonempty() {
    
    # ARGUMENTS
    local file_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    [[ -s "${file_path}" ]]
}

# file_check_executable
# Description: Check that file is executable
# Usage: file_check_executable <file_path>
file_check_executable() {
    
    # ARGUMENTS
    local file_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    [[ -x "${file_path}" ]]
}

######################### TOOL CHECKS ####################

# tool_check_binary
# Description: Check that tool exists in PATH
# Usage: tool_check_binary <tool>
tool_check_binary() {
    
    # ARGUMENTS
    local tool="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    command -v "${tool}" >/dev/null 2>&1
}

# tool_check_runtime
# Description: Check that tool responds to version flag
# Usage: tool_check_runtime <tool>
tool_check_runtime() {
    
    # ARGUMENTS
    local tool="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    "${tool}" -version    >/dev/null 2>&1 || \
    "${tool}" --version   >/dev/null 2>&1
}


# tool_check_subcommand
# Description: Check that tool subcommand exists (via help output)
# Usage: tool_check_subcommand <tool> <subcommand>
tool_check_subcommand() {
    
    # ARGUMENTS
    local tool="${1-}"
    local command="${2-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    "${tool}" "${command}" -h 2>&1 | grep -q "Usage" || \
    "${tool}" "${command}" --help 2>&1 | grep -q "Usage"
}

# tool_check_array
# Description: Validate tools from array of checks (type:command:subcommand)
# Usage: tool_check_array <array_name>
# Entry format:
#   binary:command
#   runtime:command
#   subcommand:command:subcommand
# Example:
#   tools=("binary:bwa" "subcommand:samtools:view")
#   tool_check_array tools
tool_check_array() {
    
    # ARGUMENTS
    local array_name="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    local -n entries="${array_name}"

    for entry in "${entries[@]}"; do
        
        IFS=':' read -r type command subcommand <<< "${entry}"

        case "${type}" in

            binary)
                tool_check_binary "${command}" || error_return "Failed binary check: ${command}"
                ;;

            runtime)
                tool_check_runtime "${command}" || error_return "Failed runtime check: ${command}"
                ;;

            subcommand)
                tool_check_subcommand "${command}" "${subcommand}" || error_return "Failed subcommand check: ${command} ${command}"
                ;;

            *)
                error_return "Unknown check type: ${type}"
                ;;

        esac

    done
}

######################### CONTRACT CHECKS ################

contract_check_array() {

    # ARGUMENTS
    local array_name="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    local -n entries="${array_name}"

    for entry in "${entries[@]}"; do
        
        echo "Running check - ${entry}"
        
        IFS=':' read -r key value <<< "${entry}"

        case "${key}" in

            array)
                variable_check_nonempty "${value}" || error_return "Variable is empty or not set: ${value}"
                array_check_nonempty "${value}" || error_return "Array has no entries: ${value}"
                ;;

            file)
                file_check_exists "${value}" || error_return "File not found: ${value}"
                file_check_nonempty "${value}" || error_return "File is empty: ${value}"
                ;;

            exec)
                file_check_exists "${value}" || error_return "File not found: ${value}"
                file_check_nonempty "${value}" || error_return "File is empty: ${value}"
                file_enforce_executable "${value}" || error_return "Failed to enforce executable: ${value}"
                ;;
            
            var)
                variable_check_nonempty "${value}" || error_return "Variable is empty or not set: ${value}"
                ;;

            dir)
                directory_check_exists "${value}" || error_return "Directory not found: ${value}"
                directory_check_nonempty "${value}" || error_return "Directory is empty: ${value}"
            
            *)
                error_return "Unknown check type: ${key}"
                ;;

        esac

    done

}

######################### ACTIONS/MUTATION ###############

# directory_create
# Description: Create directory (mkdir -p)
# Usage: directory_create <directory_path>
directory_create() {
    
    # ARGUMENTS
    local directory_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    mkdir -p "${directory_path}"
}

# directory_remove
# Description: Remove directory and all contents recursively (rm -rf)
# Usage: directory_remove <directory_path>
# Example:
#   directory_remove "/path/to/dir"
directory_remove() {
    
    # ARGUMENTS
    local directory_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    rm -rf "${directory_path}" || return 1
}

# file_make_executable
# Description: Make file executable (chmod +x)
# Usage: file_make_executable <file_path>
file_make_executable() {
    
    # ARGUMENTS
    local file_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    chmod +x "${file_path}" || return 1
}

# file_enforce_executable
# Description: Ensure file is executable, fix if needed
# Usage: file_enforce_executable <file_path>
# Behavior:
#   - silent if already executable
#   - warns and fixes if not
#   - errors if fix fails
file_enforce_executable() {
    
    # ARGUMENTS
    local file_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    file_check_executable "${file_path}" && return 0
    warning_message "${FUNCNAME[0]} - File not executable, applying chmod +x"
    file_make_executable "${file_path}" || error_return "${FUNCNAME[0]} - Failed to make file executable: ${file_path}"
}

######################### STRING/PARSING #################

# string_split_values
# Description: Split string into key/value using delimiter
# Usage: string_split_values <string> <delimiter> <key_var> <value_var>
# Example:
#   entry="a:b"
#   string_split_values "$entry" ":" key value
#   echo "$key $value"
string_split_values() {
    
    # ARGUMENTS
    local string="${1-}"
    local delimiter="${2-}"
    local key_name="${3-}"
    local value_name="${4-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    if [[ "${string}" != *"${delimiter}"* ]]; then
        error_message "${FUNCNAME[0]} - '${delimiter}' delimiter not found in string"
        return 3
    fi

    local -n key="${key_name}"
    local -n value="${value_name}"

    key="${string%%"${delimiter}"*}"
    value="${string#*"${delimiter}"}"
}

######################### IO/ENV #########################

# write_env
# Description: Write stdin to file (overwrite)
# Usage: write_env <file_path>
# Example:
#   echo "VAR=1" | write_env env.txt
write_env() {
    
    # ARGUMENTS
    local file_path="${1-}"

    # VALIDATION
    for entry in "$@"; do
        argument_check_nonempty "${entry}" || return $?
    done

    # FUNCTION
    cat > "${file_path}"
}