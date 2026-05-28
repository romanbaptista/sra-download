# `arrays`

# Overview
The `arrays/` directory defines the declarative contract layer of the pipeline.

These files contain no executable logic and instead declare:
- required configuration variables
- required system binaries
- execution modules
- preflight validation order

Together, they define the Application Binary Interface (ABI) of the pipeline.

# Design Principles
- Declarative only — no functions, no control flow
- Single source of truth for pipeline structure
- Explicit contracts that enforce reproducibility
- Consumed by preflight and pipeline layers
- No hidden dependencies — everything required is declared here

# Files and Responsibilities
The directory contains four primary array definitions:

| File | Responsibility |
|------|----------------|
| `array_variables.sh` | Defines required user configuration variables |
| `array_binaries.sh` | Defines required system binaries |
| `array_pipeline.sh` | Defines execution modules and their order |
| `array_preflight.sh` | Defines ordered preflight validation steps |

# Contract Types

## Variable Contract (`array_variables.sh`)
Defines all variables that must be provided in `config.sh`.

Example:
```bash
VARIABLE_ARRAY=(
    BIOPROJECT
)
```

Validation is handled by the preflight layer.

## Binary Contract (`array_binaries.sh`)
Defines all required system-level commands used by the pipeline.

- Only include commands explicitly used in scripts
- Do not include tool-specific binaries (these are handled in tool preflight scripts)

Example:

```bash
BINARY_ARRAY=(
    bash
    tmux
    wget
    tar
)
```

## Execution Contract (`array_pipeline.sh`)
Defines the execution modules for the pipeline.

- Order of entries defines execution order
- The pipeline orchestrator (`pipeline.sh`) must not be included

Example:

```bash
PIPELINE_ARRAY=(
    "1-bioproject-srr.sh"
    "2-srr-sra.sh"
)
```

## Preflight Contract (`array_preflight.sh`)
Defines the ordered execution of preflight validation scripts.

- Order is critical
- Scripts must reflect dependency flow

Example:

```bash
PREFLIGHT_ARRAY=(
    "preflight_paths.sh"
    "preflight_variables.sh"
    "preflight_binaries.sh"
    "preflight_pipeline.sh"
    "preflight_edirect.sh"
    "preflight_sratoolkit.sh"
)
```

# Execution Relationships
Arrays are consumed by different parts of the pipeline:
- Variable validation
- Binary validation
- Execution orchestration
- Preflight sequencing

| Array | Consumed By | Purpose |
|------|-------------|--------|
| `VARIABLE_ARRAY` | `preflight_variables.sh` | Validate user input |
| `BINARY_ARRAY` | `preflight_binaries.sh` | Validate system environment |
| `PIPELINE_ARRAY` | `pipeline/pipeline.sh` | Define execution modules |


# Key Rules
- Do not include logic or validation in arrays
- Do not dynamically modify arrays at runtime
- Ensure all entries correspond to real scripts, variables, or binaries
- Maintain strict alignment with preflight and pipeline layers

# Summary
The `arrays/` directory defines the contractual backbone of the pipeline:
- what must be provided
- what must be validated
- what will be executed
- and in what order

All downstream behaviour is derived from these declarations, ensuring deterministic and reproducible execution.