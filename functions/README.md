# `functions`

# Overview
The `functions/` directory contains all reusable, atomic logic used throughout the pipeline.

These scripts provide:
- validation primitives
- filesystem and variable checks
- tool installation helpers
- shared utility functions

They represent the execution logic layer, but are strictly limited to stateless, reusable operations.

# Design Principles

| Principle | Description |
|----------|------------|
| Atomicity | Functions perform a single task |
| No orchestration | Control flow handled outside functions |
| Validation-first | Inputs are always validated before use |
| Return-based | Failures propagate via return codes |

# File Overview

The `functions/` directory is structured into:
- a shared base layer (`functions_base.sh`)
- pipeline-specific helpers (`functions_pipeline.sh`)
- tool-specific modules (`functions_edirect.sh`, `functions_sratoolkit.sh`)

Each file has a clearly defined scope and responsibility.

| File | Responsibility |
|------|----------------|
| `functions_base.sh` | Core validation, filesystem checks, and error handling |
| `functions_pipeline.sh` | Shared pipeline helpers (e.g. environment writing) |
| `functions_edirect.sh` | Atomic EDirect download and environment setup logic |
| `functions_sratoolkit.sh` | Atomic SRA Toolkit download and extraction logic |

## `functions_base.sh`
This file defines all core helper functions used across the entire pipeline.

It includes:
- argument validation (`arg_check_nonempty`)
- variable validation (`variable_check_nonempty`)
- array validation (`array_check_nonempty`)
- file and directory checks
- binary and tool validation
- error handling (`fail_message`)

All scripts depend on this file, and it must be sourced wherever functions are required.
This file is the foundation of the pipeline contract system.

## `functions_pipeline.sh`
Contains shared helpers used across pipeline components.

Typical responsibilities include:
- writing environment files (`write_env`)
- shared execution utilities
- small cross-cutting helpers used in multiple scripts

This file does not implement pipeline logic, but supports consistent behaviour across modules and preflight scripts.

## `functions_edirect.sh`
Provides atomic helpers for working with NCBI EDirect.

Responsibilities:
- downloading and installing EDirect
- ensuring availability of required commands (e.g. `esearch`)
- minimal environment setup (e.g. `PATH` updates)

Key principle:
- Contains only atomic tool logic, not validation or orchestration

All validation and installation decisions are handled in `preflight_edirect.sh`.

## `functions_sratoolkit.sh`
Provides atomic helpers for working with the SRA Toolkit.

Responsibilities:
- downloading toolkit archives
- extracting tool directories
- setting up runtime environment (`PATH`)

Key characteristics:
- restart-safe downloads (skip if archive exists)
- minimal assumptions about environment
- no orchestration logic

Validation and setup decisions are handled in `preflight_sratoolkit.sh`.

# Execution Pattern
Functions follow a strict internal structure:
- Argument validation
- Execution logic
- Return (no exit)

Example pattern:
```bash
my_function() {
    local arg="${1-}"

    # VALIDATION
    arg_check_nonempty "${arg}" || return $?

    # FUNCTION
    do_something "${arg}" || return 1
}
```

# Usage in Pipeline
Functions are used across:
- preflight scripts (validation, installation, setup)
- pipeline scripts (filesystem operations)
- module scripts (execution tasks)

Modules must explicitly source `functions_base.sh` to access core helpers.

# Error Handling
Functions:
- return non-zero on failure
- do not terminate execution directly

Pipeline scripts handle failure via:
```bash
function_call || fail_message "error description"
```

This ensures:
- consistent failure messaging
- controlled pipeline termination
- clear separation of logic vs control flow

# Key Rules
- Do not include orchestration logic in functions
- Do not use exit inside functions (except via fail_message)
- Always validate inputs before performing actions
- Keep functions small and focused
- Avoid hidden dependencies or global state

# Summary
The `functions/` directory provides the reusable building blocks of the pipeline.

It enables:
- consistent validation and error handling
- clean separation between logic and execution
- modular, testable, and maintainable code

All higher-level behaviour in the pipeline is constructed from these atomic components.