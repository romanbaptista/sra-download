# `preflight/`

# Purpose
The `preflight/` directory is responsible for validation, installation, and environment construction.

It represents a strict fail-fast stage in the pipeline lifecycle, ensuring that all requirements are satisfied before any execution begins.

At this stage, the pipeline verifies configuration, prepares tools, and constructs deterministic runtime environments. If any requirement is not met, execution is halted immediately.

# Role in the Pipeline
Preflight acts as the bridge between configuration and execution.

Its responsibilities include:
- validating user-defined configuration
- verifying system-level dependencies
- installing required tools where necessary
- constructing runtime environments

Execution depends entirely on the successful completion of preflight. No downstream stages proceed unless this stage completes without errors.

# Tool Workflow
Each tool follows a standardised lifecycle during preflight:
```text
check_<tool>()
→ install_<tool>()
→ write .env file
→ source environment
→ tool_check_array
```

This workflow ensures that tools are:
- available and functional
- correctly installed when absent
- prepared for execution via deterministic runtime environments

| Step             | Role                                      |
|------------------|-------------------------------------------|
| check_<tool>()   | verifies tool availability                |
| install_<tool>() | installs tool if missing                  |
| write .env file  | generates deterministic environment file  |
| source           | validates environment usability           |
| tool_check_array | verifies tool functionality               |

# Environment Files
Environment files define the runtime interface for tools and are created during preflight.

### Location
```text
envs/<tool>.env
```

### Contents
Each `.env` file contains the minimal environment required to execute a tool.
Typically:
- updates to PATH to expose binaries
- optional variables such as:
```text
LD_LIBRARY_PATH
PYTHONPATH
```

These files are deterministic and tool-specific.

# Environment Construction
During preflight:
- environments are written deterministically to `.env` files
- contents are fully defined and reproducible
- no external or implicit dependencies are included

This ensures that all environments are explicitly controlled and consistent across runs.

# Environment Reconstruction
Although environments are created during preflight, they are not retained in memory for execution.

Instead:
- execution stages explicitly validate `.env` files
- environments are reconstructed by sourcing these files
- runtime behaviour depends entirely on this reconstruction

| Stage       | Role                                         |
|-------------|----------------------------------------------|
| Preflight   | creates deterministic `.env` files              |
| Execution   | validates and sources `.env` files              |
| Runtime     | tools run using reconstructed environments    |

# Fail-Fast Behaviour
Preflight enforces strict fail-fast validation:
- missing variables cause immediate termination
- missing files or directories halt execution
- failed tool checks stop the pipeline

This guarantees that execution never proceeds under invalid conditions.

# Deterministic Preparation
Preflight ensures deterministic preparation by:
- installing tools in a standardised structure
- generating consistent `.env` files
- validating all inputs and dependencies

This eliminates variability in runtime behaviour and ensures reproducibility across environments.

# Separation from Execution
Preflight is strictly separated from execution:
- it does not perform computation
- it does not process input data
- it does not generate outputs

Its sole role is to prepare and validate the system so that execution can proceed safely.

# Reproducibility
Preflight is central to reproducibility:
- all environments are constructed explicitly
- all dependencies are validated before execution
- no hidden state is carried into runtime

Because execution depends solely on preflight outputs, results remain consistent across runs.

# Summary
The `preflight/` directory implements the validation and preparation stage of the pipeline. By enforcing strict fail-fast behaviour and constructing deterministic runtime environments, it ensures that execution begins only under fully validated and reproducible conditions.