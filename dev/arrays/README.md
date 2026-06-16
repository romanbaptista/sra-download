# `arrays/`

# Purpose

The `arrays/` directory defines ordered lists that control pipeline behaviour.

These arrays act as the pipeline’s ABI (Application Binary Interface), providing a declarative interface that governs how the pipeline is validated and executed.

They determine:
- execution order  
- validation sequence  
- variable exposure  

# Core Concept

Arrays are the **single source of truth** for pipeline structure and ordering.

They contain no logic and do not perform any computation. Instead, they define *what* should happen, while execution layers define *how* it happens.

# Common Arrays
The following arrays are central to pipeline operation:

- `PREFLIGHT_ARRAY`  
  Defines the ordered sequence of validation and setup stages executed during preflight.

- `PIPELINE_ARRAY`  
  Defines the execution modules that make up the pipeline.

- `VARIABLE_ARRAY`  
  Defines all required user-provided configuration variables.

- `EXPORT_ARRAY`  
  Defines the set of variables exposed across execution boundaries (e.g. SLURM jobs).

- `BINARY_ARRAY`  
  Defines required system-level command dependencies.

# Array Roles

| Array Name      | Role                                      |
|----------------|-------------------------------------------|
| `PREFLIGHT_ARRAY`| defines validation and setup order        |
| `PIPELINE_ARRAY` | defines execution modules                 |
| `VARIABLE_ARRAY` | defines required user configuration       |
| `EXPORT_ARRAY`   | defines variables exposed across boundaries|
| `BINARY_ARRAY`   | defines required system command dependencies |

# Execution Role
Arrays are consumed by core orchestration layers:

- **Preflight controller**  
  Uses arrays to determine validation order and ensure all requirements are satisfied before execution.

- **Pipeline orchestrator**  
  Uses arrays to determine execution modules and runtime behaviour.

Because arrays are authoritative and declarative, they ensure that execution order and validation flow remain consistent across runs.

# Key Principle

Arrays form the **pipeline ABI**, acting as the formal interface between pipeline layers.

They guarantee that:
- execution order is explicit  
- validation is deterministic  
- runtime behaviour is reproducible  

# Declarative Design

Arrays are purely declarative:
- they describe structure, not behaviour  
- they define dependencies without implementing them  
- they separate configuration from execution logic  

This design ensures clarity, maintainability, and portability.

# Reproducibility

Because all ordering and structure is defined in arrays:
- execution behaviour does not depend on implicit state  
- pipeline structure is fully transparent  
- results are reproducible across environments  

# Summary

The `arrays/` directory defines the structural backbone of the pipeline. By acting as a declarative ABI, it ensures that all validation, execution, and data flow are explicitly defined and consistently applied.