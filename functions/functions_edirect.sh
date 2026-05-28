#!/bin/bash

# download_edirect
download_edirect() {
    local url="${1-}"

    # VALIDATION
    arg_check_nonempty "${url}" || return $?

    # FUNCTION
    # Download EDirect from given URL
    sh -c "$(curl -fsSL "${url}")" || return 1
    # Ensure current shell can see esearch
    export PATH="${HOME}/edirect:${PATH}"

    return 0
}