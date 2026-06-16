# `envs/`

# Purpose
The `envs/` directory stores runtime environment files for all tools used within the pipeline.

Each tool produces a corresponding .env file, which defines the environment required for its execution. These files serve as the only interface between tool installation and runtime usage.

# Contents
Each `.env` file defines the environment variables required to run a specific tool.

Typical contents include:
- modifications to PATH to expose tool binaries
- optional runtime variables such as:
```text
LD_LIBRARY_PATH
PYTHONPATH
```

Environment files are minimal and tool-specific, containing only what is required to execute the tool reliably.

# Key Principle
`.env` files are the only runtime interface for tools.

No environment state is assumed outside these files. Every execution context must be constructed explicitly using these environment definitions.

This ensures that tool execution remains independent of system configuration or prior environment state.

# Execution Role
Environment files are used at two distinct stages:

- **Creation (preflight)**  
  During preflight, tool environments are constructed and written deterministically to `.env` files.

- **Reconstruction (execution)**  
  During execution, module scripts validate and source these .env files to reconstruct the required runtime environment.

This process replaces traditional approaches such as activating environments or loading modules.

# Environment Model

| Stage       | Role                                      |
|------------|-------------------------------------------|
| Preflight  | creates deterministic `.env` files          |
| Execution  | validates and sources `.env` files          |
| Runtime    | tools execute using reconstructed environment |

# Rules
- `.env` files must be deterministic and reproducible
- `.env` files must be validated before being sourced
- no external or implicit dependencies are allowed
- environment state must be fully defined within the `.env` file

These rules ensure consistent behaviour across different systems and execution contexts.

# Explicit Environment Reconstruction
The pipeline enforces explicit environment reconstruction:
- environments are not inherited
- runtime state is rebuilt for each execution context
- tool execution depends solely on validated .env files

This eliminates ambiguity and ensures consistent results across runs.

# Reproducibility
The use of `.env` files guarantees reproducibility by:
- defining exact runtime environments
- avoiding reliance on external configuration
- ensuring identical execution conditions across systems

Given the same `.env` files, tools will behave consistently regardless of where the pipeline is executed.

# Summary
The `envs/` directory provides a clean and deterministic interface between tool installation and execution. By defining runtime environments explicitly through .env files, the pipeline ensures reproducible, portable, and consistent tool execution across all stages.