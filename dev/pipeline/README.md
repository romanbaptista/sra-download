# `pipeline/`

# Purpose
The `pipeline/` directory contains execution modules and the pipeline orchestrator responsible for performing all computational work.

Modules operate under strict assumptions:
- tools are already installed
- runtime environments are available
- all validation has been completed

As a result, modules are limited to execution-only responsibilities and do not perform installation or validation.

# Execution Model
Pipeline modules follow a strict execution structure:
```text
CONTRACT → ENVS → MAIN
```

This structure enforces clear separation between validation, environment preparation, and computation.

## CONTRACT
The CONTRACT stage defines the structural requirements for each module.

It is responsible for:
- declaring required variables
- validating that inputs and dependencies are present
- ensuring that the module operates under valid assumptions

This stage guarantees that execution begins only when all prerequisites are satisfied.

## ENVS
The ENVS stage reconstructs runtime environments needed for execution.

Environment files are defined externally and must be:
- validated for existence
- verified as non-empty
- sourced into the current shell

This ensures that each module executes within a fully defined and reproducible runtime environment.

| ENVS Step        | Role                                      |
|-----------------|-------------------------------------------|
| Validation       | ensure `.env` files exist and are non-empty |
| Reconstruction   | source environment files                  |
| Runtime Setup    | provide tool access via environment       |

## MAIN
The MAIN stage performs all computational work.

This includes:
- processing inputs provided by upstream stages
- invoking tool binaries
- generating outputs

MAIN is strictly execution-only and does not modify configuration, install tools, or perform validation beyond runtime checks.

# Execution Boundary Rule
Each pipeline execution stage operates under strict execution boundaries.
When modules are run within a SLURM job context:
- no environment state is inherited
- only explicitly provided variables are available
- all runtime environments must be reconstructed

This ensures that execution is isolated, reproducible, and independent of external state.

# Separation of Responsibilities

| Stage     | Responsibility                          |
|-----------|------------------------------------------|
| CONTRACT  | define and validate requirements         |
| ENVS      | reconstruct runtime environment          |
| MAIN      | perform computation                      |

# Environment Reconstruction
A critical aspect of the execution model is explicit environment reconstruction.
- runtime environments are not inherited
- each module sources required `.env` files independently
- tool execution depends entirely on reconstructed environments

This guarantees consistent behaviour across different execution contexts.

# Deterministic Execution
Modules are designed to produce deterministic outputs:
- inputs are explicitly defined
- execution order is controlled externally
- outputs are written to structured directories

This ensures reproducible behaviour across runs and environments.

# Relationship to Other Layers
The `pipeline/` layer depends on upstream layers but does not perform their responsibilities:
- validation and setup are handled in preflight
- tool installation is resolved in lower layers
- contracts define requirements but do not execute logic

This separation ensures that modules remain focused purely on computation.

# Summary
The `pipeline/` directory contains execution-only modules that operate within a strictly defined and validated environment. 

By enforcing the CONTRACT → ENVS → MAIN structure and isolating execution from validation and installation, it enables deterministic, reproducible, and modular pipeline behaviour.