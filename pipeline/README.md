# `pipeline`

# Overview
The `pipeline/` directory contains the execution layer of the pipeline.

| File | Responsibility |
|------|----------------|
| `pipeline.sh` | Orchestrates execution of pipeline modules |
| `1-bioproject-srr.sh` | Discovers accessions from BioProject using EDirect |
| `2-srr-sra.sh` | Downloads `.sra` files using SRA Toolkit |

These scripts implement the data processing workflow, operating on a fully validated environment created by the preflight layer.

All execution in this directory assumes that:
- all required variables are defined
- all required tools are installed and functional
- all directories are correctly initialised

No validation or setup logic is duplicated here.

# Module Naming Convention
Module scripts follow the pattern:
```text
<stage>_<input>-<output>.sh
```

This reflects the transformation performed at each stage of the pipeline.

Examples:
```text
- 1_bioproject-srr.sh   → resolves BioProject → SRR accessions
- 2_srr-sra.sh          → downloads SRR → .sra files
```

This convention provides:
- clear indication of data flow
- consistent naming across pipelines
- improved readability in logs and outputs

# Design Contract
All scripts in this directory adhere to the following principles:
- single responsibility per script
- explicit input and output paths
- strict separation between validation and execution
- deterministic execution behaviour
- no reliance on implicit working directories
- no reliance on undeclared global state
- compatibility with execution boundaries (`tmux` or `SLURM`)

Modules assume that all preflight invariants have already been enforced.

# Execution Model
The execution layer is orchestrated by `pipeline.sh`

This script is launched:
- inside a controlled execution environment (`tmux` or scheduler)
- after preflight validation has completed successfully

Execution behaviour is defined by `arrays/array_pipeline.sh`, which lists all modules to be executed.

# Execution Order
Modules are executed sequentially based on the order defined in `PIPELINE_ARRAY`

Example:
```text
pipeline.sh
1-bioproject-srr.sh
2-srr-sra.sh
```

The execution model is:
- deterministic
- single-process (sequential)
- login-node friendly
- easily extendable to alternative execution strategies

| Component | Role |
|----------|------|
| Orchestrator | Controls execution order and failure handling |
| Modules | Perform execution tasks only |
| `PIPELINE_ARRAY` | Defines module execution order |

## `pipeline.sh`

### Role
`pipeline.sh` is the internal execution controller for the pipeline.

It coordinates module execution but does not perform any data processing directly.

### Responsibilities
- Reads the module list from `PIPELINE_ARRAY`
- Iterates through modules in order
- Executes each module as a separate process
- Ensures immediate termination on failure
- Provides structured logging output

### Guarantees
- deterministic execution order
- no duplication of preflight validation
- clean process isolation between modules
- compatibility with tmux and SLURM execution models

# Module Overview
Each module implements a single stage of the pipeline.

Modules are:
- execution-only
- stateless beyond defined inputs/outputs
- restart-safe where possible

## `1-bioproject-srr.sh`

### Role
Discovers BioSample and SRA run accessions associated with a BioProject.

### Inputs
```text
BIOPROJECT (from config.sh)
EDirect command-line tools (validated during preflight)
```

## Workflow
- Queries the BioProject database
- Retrieves BioSample UIDs
- Fetches metadata
- Extracts BioSample accessions (SAMN)
- Derives SRA run accessions (SRR)
- Writes output files to disk

### Outputs
```text
output/1-bioproject-srr/
├── biosample_uids.txt
├── biosample_docsum.xml
├── biosample_samn_accessions.txt
└── biosample_srr_accessions.txt
```

### Guarantees
- deterministic accession discovery
- explicit failure if no accessions are found
- output files are overwritten per run
- relies only on preflight-validated tool availability

## `2-srr-sra.sh`

### Role
Downloads `.sra` files corresponding to SRR accessions.

### Inputs
```text
SRR accession list from 1-bioproject-srr.sh
SRA Toolkit (prefetch, vdb-config)
network access
```

### Expected Input Structure
```text
output/1-bioproject-srr/
└── biosample_srr_accessions.txt
```

### Workflow
- Reads SRR accessions sequentially
- Normalises each accession ID
- Creates a dedicated directory per accession
- Configures a per-accession VDB environment
- Downloads `.sra` files using prefetch
- Skips already downloaded accessions
- Aborts immediately on failure

### Outputs
```text
output/2-srr-sra/
└── SRRXXXXXXXX/
    ├── SRRXXXXXXXX.sra
    └── .vdb-config
```

### Guarantees
- per-accession isolation
- restart-safe downloads
- deterministic directory structure
- no shared state between runs

# Execution Boundary Considerations
This pipeline supports multiple execution contexts:
- tmux-based execution (default for login nodes)
- scheduler-based execution (e.g. SLURM with exported variables)

In all cases:
- required variables must be explicitly passed into the execution environment
- modules assume variables are already defined and valid

# Key Rules
- do not include validation logic in modules
- do not install tools during execution
- do not modify global configuration
- always use absolute paths
- ensure restart-safe behaviour where applicable
- maintain strict separation between orchestration and execution

# Summary
The `pipeline/` directory implements the execution phase of the pipeline.

It provides:
- a deterministic orchestration layer
- modular, composable execution scripts
- a clean boundary between validation and execution

This design ensures that all runtime behaviour is:
- predictable
- reproducible
- easy to extend and maintain