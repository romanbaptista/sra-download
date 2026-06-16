# `contracts/`

# Purpose
The `contracts/` directory defines declarative validation rules for scripts and pipeline components.

Contracts specify what must exist before execution proceeds. They establish the required structure and inputs for each script, ensuring that all prerequisites are satisfied before any runtime behaviour is executed.

Contracts do not perform execution and contain no operational logic. Their sole purpose is to define and enforce requirements.

# Responsibilities
Contracts define the expectations that each script must satisfy prior to execution.

These include:
- required variables that must be defined
- required external scripts or sources that must be available
- structural validation rules that ensure consistency

By defining these requirements explicitly, contracts enforce uniformity across all components of the pipeline.

| Component    | Purpose                                      |
|--------------|----------------------------------------------|
| `GUARD_ARRAY`  | defines required variables                   |
| `SOURCE_ARRAY` | defines required scripts to be sourced       |
| `CHECK_ARRAY`  | defines structural validation rules          |

# Key Principle
Contracts are strictly declarative.

They describe requirements, not behaviour. They do not execute code, perform installation, or manipulate runtime state.

This ensures that the conditions required for execution are clearly specified and validated independently of how execution is carried out.

# Execution Role
Contracts are evaluated prior to execution phases to prevent invalid states from propagating through the pipeline.

They ensure that:
- all required variables are defined and non-empty
- required files, directories, and dependencies are present
- script-level assumptions are explicitly validated

This fail-fast validation model guarantees that execution only proceeds when all conditions are satisfied.

# Separation from Execution
Contracts operate independently of both validation logic and execution logic.

- They define what must be true, not how to verify it
- They remain separate from functions that perform checks
- They do not contain environment setup or execution behaviour

This separation ensures clarity and prevents overlap between definition and implementation layers.

# Validation Model

| Validation Stage | Responsibility                          |
|-----------------|-----------------------------------------|
| `GUARDS`          | ensure required variables are defined   |
| `SOURCE`          | ensure required scripts are available   |
| `CHECKS`          | ensure structural consistency           |

# Consistency Across Scripts
Every script within the pipeline adheres to the same contract structure.

This ensures:
- predictable validation behaviour
- consistent handling of inputs and dependencies
- uniform enforcement of requirements across all stages

By standardising contracts, the pipeline maintains a coherent and maintainable structure.

# Reproducibility
Contracts contribute directly to reproducibility by ensuring that:
- all execution prerequisites are explicitly declared
- no implicit assumptions are made about the environment
- invalid configurations are detected early

Because all requirements are defined and validated upfront, execution outcomes remain consistent across runs and environments.

# Summary
The `contracts/` directory defines the validation interface for the pipeline. By describing requirements in a declarative and consistent manner, contracts enforce correctness, enable fail-fast validation, and ensure that execution proceeds only under valid and reproducible conditions.