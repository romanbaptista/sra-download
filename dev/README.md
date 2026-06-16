# `dev/`

# Overview
The `dev/` directory contains the full implementation of the contract-driven HPC pipeline framework.

It is the core of the system, where pipeline behaviour is defined, validated, and executed through a structured, modular architecture.

Execution follows a strict lifecycle:
```text
CONFIG → CONTRACT → VALIDATION → EXECUTION
```

This ensures that all inputs, environments, and dependencies are explicitly defined and verified before any computational work is performed.

# Structure
The directory is organised into distinct layers, each with a clearly defined responsibility:
```text
dev/
├── arrays/     # ABI and ordering definitions
├── contracts/  # declarative script contracts
├── preflight/  # validation, installation, and environment setup
├── pipeline/   # execution modules and orchestration
├── utils/      # variable and tool metadata definitions
├── functions/  # reusable implementation logic
├── installs/   # installed tool binaries
└── envs/       # runtime environment definitions
```

# Separation of Concerns
Each layer in `dev/` has a single, well-defined responsibility:

| Layer       | Responsibility                      |
|-------------|------------------------------------|
| arrays      | execution interface and ordering   |
| contracts   | declarative requirements           |
| preflight   | validation and setup               |
| pipeline    | execution                          |
| utils       | variable definitions               |
| functions   | implementation logic               |
| installs    | tool binaries                      |
| envs        | runtime environments               |

No layer overlaps in responsibility, ensuring a clean and maintainable architecture.

# Layer Descriptions

### `arrays/`
Defines the canonical arrays that form the pipeline’s execution interface and ordering.

These include:
- execution order (pipeline modules)
- validation stages (preflight)
- exported variables (execution ABI)
- required system dependencies

This layer establishes the explicit contract boundary between pipeline stages.

### `contracts/`
Provides declarative definitions for each script.

Contracts specify:
- required variables
- required inputs and environments
- expected outputs
- structural validation rules

All scripts must satisfy their contract before execution proceeds.

### `preflight/`
Implements the validation and setup phase of the pipeline.

Responsibilities include:
- validating configuration and inputs
- validating system-level dependencies
- installing tools where required
- constructing deterministic runtime environments

All preflight scripts execute in a shared shell and operate purely on validation and setup.

### `pipeline/`
Contains execution modules and the pipeline orchestrator.

Responsibilities include:
- coordinating pipeline execution
- running modules in a defined sequence
- performing data transformations

Execution modules are strictly limited to execution logic and do not perform validation or installation.

### `utils/`
Defines declarative variables and metadata used throughout the pipeline.

This includes:
- directory structures
- tool configuration parameters
- derived paths

This layer contains no executable logic and serves as a centralised source of structured configuration.

### `functions/`
Provides reusable implementation logic used across the pipeline.

This includes:
- validation helpers
- file and directory checks
- tool integration logic
- environment writing utilities

Functions are intentionally generic and stateless, enabling reuse across pipelines.

### `installs/`
Stores all tool binaries installed during preflight.

Tools are normalised into a consistent structure:
```text
installs/<tool>/bin/<binary>
```

This ensures deterministic tool resolution independent of system configuration.

### `envs/`
Stores runtime environment definitions as `.env` files.

These files define the minimal environment required to execute each tool, typically by modifying `PATH`.

They act as the sole interface between installation and execution.

# Data and Control Flow
Pipeline execution progresses through clearly defined stages:

1. **Configuration (CONFIG)**  
  User-defined parameters are loaded and validated.

2. **Contract resolution (CONTRACT)**  
  Each script defines its requirements and expected structure.

3. **Validation and setup (VALIDATION / PREFLIGHT)**  
  Inputs, dependencies, and environments are verified and constructed.
  
4. **Execution (PIPELINE / MODULES)**  
  Data processing is performed using validated inputs and reconstructed environments.

Data flows forward through the pipeline via explicitly defined outputs, ensuring that each stage consumes only validated upstream results.

# Execution Boundaries
The pipeline enforces strict execution boundaries, particularly across SLURM job submission.

When a script is executed in a new shell:
- no environment is inherited
- only explicitly exported variables are available
- runtime environments must be reconstructed from `.env` files

This ensures that execution is:
- deterministic
- reproducible
- independent of external state

# Modularity and Reusability
The design of `dev/` supports reuse across pipelines:
- tools are abstracted from execution
- validation is decoupled from runtime logic
- environments are reconstructed rather than inherited
- contracts enforce consistency across scripts

This enables the same framework to be applied to different computational workflows with minimal modification.

# Key Principles
- explicit contracts govern all behaviour
- validation precedes execution
- environments are reconstructed, not assumed
- execution is isolated from setup and installation
- all components are modular and reusable

# Summary
The `dev/` directory contains the complete implementation of a contract-driven HPC pipeline framework. Its layered design enforces strict separation between definition, validation, and execution, ensuring reproducible, deterministic, and portable workflows across HPC environments.