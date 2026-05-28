# `utils`

# Overview
The `utils/` directory contains all static variable definitions used throughout the pipeline.

These scripts define:
- directory paths
- tool parameters (URLs, versions, install locations)
- environment file locations

Importantly, `utils/` is a pure definition layer — it contains no logic, validation, or execution.

# Design Principles
- Definitions only — no functions or control flow
- No validation — all validation is handled in the preflight layer
- No side effects — sourcing these files should only introduce variables
- Centralised variable ownership — each variable is defined in the appropriate utils script
- Reusable across pipelines

# Role in the Pipeline
The `utils/` layer serves as the source of truth for derived variables.

| Aspect | Description |
|--------|------------|
| Purpose | Static variable definitions |
| Contains logic? | No |
| Performs validation? | No |
| Consumed by | Preflight and execution layers |
| Scope | Paths and tool parameters |

These variables are:
- consumed by preflight scripts for validation and setup
- propagated to the pipeline execution layer
- passed explicitly across execution boundaries (e.g. `tmux`)

This ensures that all paths and tool parameters are:
- defined once
- used consistently
- never redefined ad hoc in execution scripts

# File Overview
The directory is organised into:
- a shared path definition file (`utils_paths.sh`)
- tool-specific parameter files (`utils_<tool>.sh`)

Each file defines variables relevant to its domain and nothing more.

| File | Responsibility |
|------|----------------|
| `utils_paths.sh` | Defines core directory variables and initialises DIR_ARRAY |
| `utils_edirect.sh` | Defines EDirect download URL and environment path |
| `utils_sratoolkit.sh` | Defines SRA Toolkit version, URL, install directory, and environment file |

## `utils_paths.sh`
Defines all core directory paths derived from `ROOT_DIR`.

Typical variables include:
```text
ARRAY_DIR
FUNCTIONS_DIR
PIPELINE_DIR
PREFLIGHT_DIR
UTILS_DIR
OUTPUT_DIR
```

It also initialises `DIR_ARRAY`, which is extended later by the preflight layer.

This file establishes the directory structure contract of the pipeline.

## utils_edirect.sh
Defines all parameters required for working with EDirect.

Includes:
- download URL (`EDIRECT_URL`)
- environment file path (`EDIRECT_ENV`)

These variables are consumed by:
- `preflight_edirect.sh`
- `functions_edirect.sh`

No installation or validation logic is present here.

## utils_sratoolkit.sh
Defines all parameters required for the SRA Toolkit.

Includes:
- toolkit version (`SRA_VERSION`)
- archive name (`SRA_ARCHIVE`)
- download URL (`SRA_URL`)
- installation directory (`SRA_DIR`)
- environment file path (`SRA_ENV`)

These variables are consumed by:
- `preflight_sratoolkit.sh`
- `functions_sratoolkit.sh`

This ensures that tool configuration is centralised and consistent.

# Variable Ownership Model
Each variable is defined in the layer where its meaning originates:
- global structure → `utils_paths.sh`
- tool configuration → `utils_<tool>.sh`
- pipeline-derived values → preflight scripts

This prevents duplication and ensures clarity of responsibility.

# Usage Pattern
Utils scripts are sourced by preflight scripts:

```bash
source "${UTILS_DIR}/utils_paths.sh"
source "${UTILS_DIR}/utils_<tool>.sh"
```

Variables defined here are then:
- validated in preflight
- used throughout pipeline execution


# Key Rules
- Do not include logic (no loops, no conditionals)
- Do not perform validation
- Do not modify variables later in the pipeline
- Ensure variables are named clearly and consistently
- Keep all definitions deterministic and reproducible

# Summary
The `utils/` directory defines the static configuration layer of the pipeline.

It ensures that:
- all paths and tool parameters are declared in one place
- variable definitions are consistent and traceable
- downstream scripts can rely on a stable, validated environment

This separation is critical for maintaining a clean, reproducible, and contract-driven pipeline design.