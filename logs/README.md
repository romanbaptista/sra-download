# `logs/`

# Purpose
The `logs/` directory stores all pipeline and module execution logs, providing a complete record of workflow activity.

It enables traceability across all stages of execution and supports debugging, validation, and reproducibility of pipeline runs.

# Contents
The `logs/` directory typically includes:

- **Pipeline-level logs**  
  Capturing overall workflow execution and orchestration events.

- **SLURM job output logs**  
  Recording execution of submitted jobs, including stdout and stderr streams.

- **Module-level logs**  
  Detailing the behaviour of individual pipeline stages.

- **Stage-specific log files**  
  Corresponding to each script or processing step.

Logs are consistently named and organised to reflect the structure of the pipeline.

# Structure
Log files are structured to align with execution stages:
```text
logs/
├── sra-download.log
├── sra-download-run.log
├── preflight.log
├── pipeline.<job_id>.log
├── 1-bioproject-srr.log
├── 2-srr-sra.log
```

Key characteristics:
- one log per major script or stage
- SLURM logs include job identifiers for traceability
- naming reflects execution order and module identity

This structure allows users to quickly locate logs associated with any stage of the pipeline.

# Key Principle
Logging is centralised and structured to support reproducibility, monitoring, and debugging.

Each log file provides a deterministic record of actions performed during execution.

# Execution Role
Every stage of the pipeline writes logs to this directory.

Logs should:
- be clearly named and associated with their execution stage
- reflect the progression of the pipeline
- capture sufficient detail to support troubleshooting and validation

This ensures that the full execution lifecycle can be inspected after completion.

# Rules
- Log files must not be unintentionally overwritten
- Log output should be deterministic where possible
- All major execution steps must produce corresponding logs
- Each script writes to its own dedicated log file

These rules ensure that logs remain reliable, interpretable, and consistent across runs.

# Debugging and Traceability
The `logs/` directory is the primary interface for diagnosing issues and verifying execution.

Logs enable:
- tracing pipeline execution step-by-step
- identifying failures and their context
- verifying that each stage completed successfully
- correlating SLURM jobs with pipeline stages

Because logging is structured and stage-aligned, issues can be isolated quickly without ambiguity.

# Reproducibility
Logs play a central role in reproducibility by:
- recording execution order and outcomes
- capturing the state of each stage at runtime
- providing a consistent record across repeated runs

Given identical inputs and configuration, logs should reflect consistent execution behaviour.

# Summary
The `logs/` directory provides a structured, centralised record of pipeline execution. It enables reliable debugging, transparent monitoring, and full traceability across all stages, supporting deterministic and reproducible workflow execution.