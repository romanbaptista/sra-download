# `sra-download`

# Overview

This repository contains the `sra-download` pipeline — a modular, HPC‑compatible workflow for:

> Querying sequencing runs from an NCBI BioProject and downloading the corresponding `.sra` files in a robust, restart‑safe manner.

The pipeline is designed for execution on HPC login nodes and provides:
- Reliable querying of NCBI metadata (BioProject → BioSample → SRA run accessions)
- Deterministic downloading of `.sra` files using a pinned SRA Toolkit version
- Safe execution inside a persistent tmux session to survive disconnections
- A fully validated execution environment before any network activity occurs

Internally, the pipeline follows a contract‑driven architecture, separating:
- configuration
- validation
- execution

to ensure reproducibility, portability, and fail‑fast behaviour.

All outputs are written to a dedicated `output/` directory, allowing seamless integration with downstream workflows such as conversion, quality control, or alignment pipelines.

# Repository Structure

```text
sra-download/
├── README.md                  # Top-level overview (this file)
├── config.sh                  # User configuration (BioProject)
├── sra-download.sh            # Entry point (logging + preflight + tmux execution)
│
├── arrays/                    # Declarative pipeline contracts
│   ├── array_preflight.sh
│   ├── array_pipeline.sh
│   ├── array_variables.sh
│   └── array_binaries.sh
│
├── utils/                     # Static variable definitions (no logic)
│   ├── utils_paths.sh
│   ├── utils_edirect.sh
│   └── utils_sratoolkit.sh
│
├── functions/                 # Reusable helper functions
│   ├── functions_base.sh
│   ├── functions_pipeline.sh
│   ├── functions_edirect.sh
│   └── functions_sratoolkit.sh
│
├── preflight/                 # Validation and environment setup
│   ├── preflight.sh
│   ├── preflight_paths.sh
│   ├── preflight_variables.sh
│   ├── preflight_binaries.sh
│   ├── preflight_pipeline.sh
│   ├── preflight_edirect.sh
│   └── preflight_sratoolkit.sh
│
├── pipeline/                  # Execution layer
│   ├── pipeline.sh
│   ├── 1-bioproject-srr.sh
│   └── 2-srr-sra.sh
│
├── output/                    # Pipeline-generated data (created at runtime)
├── logs/                      # Centralised execution logs
└── env/                       # Tool environment files
```

# Workflow
At a high level, the pipeline proceeds as follows:

## Preflight validation
- Verifies all required system commands are available
- Confirms required user configuration variables are set
- Validates pipeline scripts exist and are executable
- Checks for and installs:
  - NCBI EDirect
  - SRA Toolkit (pinned version)
- Writes reproducible environment files for downstream use

## Accession discovery
- Queries the configured BioProject using EDirect
- Retrieves associated BioSample and SRA run accessions (SRR IDs)
- Writes accession lists to `output/1-bioproject-srr`

## Data acquisition
- Iterates through SRR accessions
- Downloads `.sra` files using prefetch
- Isolates each accession into its own directory
- Applies per‑accession configuration to avoid shared state
- Safely skips already-downloaded accessions

## Execution environment
- The pipeline runs inside a `tmux` session
- Any existing session is reset to ensure a clean run
- Required variables are explicitly passed into the session

# Configuration
All user‑defined parameters are located in `config.sh`

At minimum, the pipeline requires a BioProject ID:

```bash
BIOPROJECT="PRJNAXXXXXX"
```

# Usage
From the pipeline root directory:
```bash
bash sra-download.sh
```

This will:
- Run full preflight validation
- Launch a new `tmux` session
- Execute the pipeline in a clean, reproducible environment

To monitor execution:

```bash
tmux attach -t sra-download
```

To detach without stopping:
```text
Ctrl + b, then d
```

# Outputs
All outputs are written to `output/`, grouped by pipeline stage.

Example structure:
```text
output/
├── 1-bioproject-srr.sh.sh/
│   ├── biosample_uids.txt
│   ├── biosample_docsum.xml
│   ├── biosample_samn_accessions.txt
│   └── biosample_srr_accessions.txt
└── 2-srr-sra/
    └── SRRXXXXXXXX/
        └── SRRXXXXXXXX.sra
```

Each accession is stored in its own directory, allowing safe restarts and partial re‑runs.

# Architecture Summary

| Layer | Responsibility |
|------|----------------|
| `config.sh` | User configuration |
| `arrays/` | Declarative pipeline contracts |
| `utils/` | Variable definitions |
| `functions/` | Reusable helper logic |
| `preflight/` | Validation and environment setup |
| `pipeline/` | Execution orchestration |
| `modules` | Execution-only tasks |

# Further Documentation
For detailed documentation on individual components, see:
- `arrays/README.md` — contract layer and pipeline ABI
- `preflight/README.md` — validation design and responsibilities
- `pipeline/README.md` — execution model and modules
- `utils/README.md` — variable definitions
- `functions/README.md` — helper functions and abstractions

# Citation
If you use this pipeline in published work, please cite:

> Baptista, R. _sra-download: A reproducible HPC pipeline for BioProject-scale SRA data acquisition_. GitHub repository: https://github.com/romanbaptista/sra

Optionally include the commit hash or release version used.

# Why SRA Toolkit 2.10.9?
Many HPC systems provide an older SRA Toolkit module such as `sra-tools-2.10.3.tcl`, available on the RVC cluster. 

While functional, these older builds often suffer from:
- Outdated HTTPS handling (leading to prefetch failures)
- Incomplete or unstable fasterq-dump behaviour
- Bugs in VDB configuration handling
- Reduced compatibility with newer SRA accessions

Version 2.10.9 includes important improvements:
- More reliable HTTPS downloads via prefetch
- Improved stability and performance
- Better handling of per-directory configurations
- Reduced failure rates in large-scale runs

For these reasons, the pipeline installs and uses a local copy of SRA Toolkit 2.10.9 by default, ensuring consistent and reproducible behaviour across different HPC environments.