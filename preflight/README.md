# `preflight`

# Overview
The `preflight/` directory implements the validation and environment construction layer of the pipeline.

This layer is responsible for ensuring that all requirements are met before any execution begins.

It performs:
- validation of user configuration
- validation of system environment
- validation of pipeline structure
- installation and verification of required tools
- construction of runtime directories
- writing reproducible environment files

The preflight phase enforces a strict fail-fast model, guaranteeing that downstream execution begins only in a fully validated and deterministic state.

# Design Principles
- Fail-fast — any error immediately terminates the pipeline
- Validation-only responsibility — no execution logic
- Deterministic ordering — all steps run in a strictly defined sequence
- Explicit contracts — all checks are driven by arrays
- No hidden state — all required variables and tools are validated
- Reproducibility — all tool environments are captured via `.env` files

# Role in the Pipeline
The preflight layer is executed immediately after the entrypoint script and before any pipeline modules.

It ensures:
- all required variables are defined
- all required binaries are available
- all scripts are present and executable
- all tools are correctly installed and usable
- all required directories exist

Only once all checks pass does execution proceed to the pipeline stage.

# Execution Flow
Preflight is orchestrated by `preflight.sh`

This script executes a sequence of validation scripts defined in `arrays/array_preflight.sh`.

Each script is sourced in order, ensuring that:
- earlier stages construct state
- later stages validate or extend that state

# Preflight Stages
The pipeline implements the following validation stages:

### Paths
- Defines and creates directory structure
- Extends `DIR_ARRAY` with pipeline-specific paths

### Variables
- Validates required user configuration (e.g. `BIOPROJECT`)

### Binaries
- Verifies required system-level CLI tools

### Pipeline
- Confirms pipeline scripts exist and are executable

### Tools
- Installs and validates required tools: EDirect & SRA Toolkit

# Script Structure
Each preflight script follows a consistent general structure:

```text
GUARDS
SETUP
SOURCE
CHECKS
MAIN
```

- `GUARDS` validate required inputs for the script
- `SOURCE` imports required definitions
- `CHECKS` validate consumed variables or arrays
- `MAIN` performs validation or environment construction

# Tool Integration Model
Tools are handled using a consistent three-layer approach:

- `utils_<tool>.sh`
→ defines parameters (URLs, paths)

- `functions_<tool>.sh`
→ implements atomic logic (download, extract)

- `preflight_<tool>.sh`
→ performs validation and installation

This ensures:
- separation of concerns
- reproducible installations
- consistent validation across tools

# Environment Construction
The preflight layer builds the runtime environment by:
- creating required directories
- installing missing tools
- resolving tool installation paths
- writing environment files to `env/`

These `.env` files capture tool locations, ensuring consistent usage across sessions.

# Execution Relationships
Each preflight script is responsible for a specific contract:

| Script | Responsibility |
|--------|----------------|
| `preflight.sh` | Orchestrates execution of all preflight checks |
| `preflight_paths.sh` | Defines and creates required directories |
| `preflight_variables.sh` | Validates user configuration variables |
| `preflight_binaries.sh` | Validates required system binaries |
| `preflight_pipeline.sh` | Validates pipeline scripts and orchestrator |
| `preflight_edirect.sh` | Installs and validates EDirect |
| `preflight_sratoolkit.sh` | Installs and validates SRA Toolkit |

# Key Rules
- Do not include execution logic in preflight scripts
- Do not defer validation to later stages
- Always fail immediately on errors
- Only validate variables that are used by the script
- Maintain strict ordering via PREFLIGHT_ARRAY
- Keep scripts minimal and focused

# Summary
The `preflight/` directory guarantees that the pipeline runs in an environment that is:
- fully validated
- reproducible
- deterministic

By enforcing explicit contracts and fail-fast validation, it provides a clean boundary between setup and execution, ensuring that downstream pipeline stages can operate without ambiguity or hidden dependencies.