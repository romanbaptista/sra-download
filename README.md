# `sra-download`

# Overview
This repository implements a contract-driven HPC pipeline for deterministic, large-scale download of sequencing data from NCBI using SRA accessions derived from a BioProject.

The pipeline takes a BioProject identifier as input, resolves associated BioSample and SRA run (SRR) accessions, and performs reproducible, restart-safe SRA file downloads. It is designed for execution on SLURM-based HPC systems with strict validation, explicit environment reconstruction, and no reliance on implicit runtime state.

The framework enforces a clear separation between configuration, validation, environment construction, and execution, enabling reproducible behaviour across compute environments.

# Execution Flow
```text
sra-download.sh
→ sra-download-run.sh
→ preflight (validation + tool setup + environment creation)
→ pipeline.sh (SLURM submission)
→ modules (execution only)
```

# Stage descriptions

1. **Entry (`sra-download.sh`)**  
  Starts a clean tmux session and launches the pipeline runner.

2. **Runner (`sra-download-run.sh`)**  
  Loads configuration, validates environment paths, executes preflight, and submits the pipeline orchestrator.

3. **Preflight (`dev/preflight/`)**  
  Performs strict validation and setup:
    - validates user configuration
    - validates system dependencies
    - installs tools if required
    - constructs deterministic `.env` runtime environments

4. **Pipeline (`dev/pipeline/pipeline.sh`)**  
  Executes within SLURM and orchestrates module execution using a validated runtime ABI.

5. **Modules (`dev/pipeline/*.sh`)**  
  Perform execution-only tasks:
    - `1-bioproject-srr.sh` → resolves BioProject → SRR accessions
    - `2-srr-sra.sh` → downloads `.sra` files per accession

# Core Design Principles
- **Install-time complexity, runtime simplicity**  
  All installation and environment construction occurs during preflight.

- **No hidden environment state**  
  Every execution step reconstructs its environment explicitly.

- **No conda activation at runtime**  
  Tools are executed via projected binaries and `.env` files.

- **Binary projection + `PATH` injection**  
  Only required binaries are exposed via controlled `PATH` modification..

- **Explicit contracts at every layer**  
  Each script declares and validates its required inputs and structure before execution.

# Tool Model
All tools are resolved to deterministic locations:
```text
installs/<tool>/bin/<binary>
envs/<tool>.env
```

Runtime execution uses:
```text
source envs/<tool>.env
```

This ensures:
- consistent tool resolution across environments
- no dependency on system PATH
- reproducible execution across HPC systems

# Inputs

### `BIOPROJECT`
- NCBI BioProject accession ID provided in `config.sh`

# Outputs
Outputs are written to:
```text
output/
├── 1-bioproject-srr/
│   ├── biosample_uids.txt
│   ├── biosample_docsum.xml
│   ├── biosample_samn_accessions.txt
│   └── biosample_srr_accessions.txt
│
├── 2-srr-sra/
│   └── <SRR>/
│       ├── <SRR>.sra
│       └── .vdb-config
```

Key properties:
- deterministic directory structure
- per-accession isolation
- restart-safe execution (existing files are skipped)

# Repository Structure
```text
dev/
  arrays/      # contract-defined arrays (pipeline, preflight, exports, etc.)
  contracts/   # script-specific contract definitions
  preflight/   # validation + setup layer
  pipeline/    # execution modules and orchestrator
  utils/       # variable definitions and helpers
  functions/   # reusable validation and tool logic
  installs/    # tool binaries (installed during preflight)
  envs/        # runtime environment definitions

logs/
output/
```

# Usage

Set:
```bash
BIOPROJECT="PRJXXXXXXX"
```

Run pipeline:
```bash
bash sra-download.sh
```

Monitor execution:
```bash
tmux attach -t sra-download
```

# Reproducibility
This pipeline guarantees:
- deterministic execution order
- strict validation before execution
- explicit environment reconstruction at every boundary
- no reliance on inherited state or system configuration

All outputs can be reproduced given:
- the same input configuration
- the same pipeline version
- access to the same upstream data sources

# Summary
This pipeline provides a minimal, robust, and fully reproducible solution for BioProject-based SRA data acquisition, built on a contract-driven architecture that ensures correctness, portability, and scalability across HPC environments.

# Citation
If you use this pipeline in your work, please cite it as:

> Baptista, R. (2026).
_sra-download: A contract-driven HPC pipeline for deterministic retrieval of SRA data from NCBI BioProjects._
Available at: https://github.com/romanbaptista/sra-download