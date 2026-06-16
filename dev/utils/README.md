# `utils/`

# Purpose
The `utils/` directory defines tool metadata only.

It provides a declarative layer that describes how tools are represented within the pipeline, without implementing any logic. This metadata is consumed by downstream layers to perform installation, validation, and integration.

No execution, validation, or installation logic exists in this layer.

# Structure
Each tool must have a corresponding metadata definition file:
```text
utils_<tool>.sh
```

These files define all information required to identify, install, and reference a tool within the pipeline.

# Required Variables
Each tool definition must include a core set of variables that establish its identity and runtime interface.

| Variable           | Description                                  |
|-------------------|----------------------------------------------|
| TOOL_NAME         | canonical tool identifier                    |
| TOOL_DIR          | installation directory for the tool          |
| TOOL_ENV          | path to the tool's .env file                 |
| TOOL_BINARY       | name of the executable                       |
| TOOL_BINARY_PATH  | full path to the executable binary           |

# Optional Variables
Additional variables may be defined to support tool acquisition and installation.

| Variable              | Description                                 |
|----------------------|---------------------------------------------|
| TOOL_URL             | source URL for tool download                |
| TOOL_TARBALL         | archive filename for tarball installations  |
| TOOL_CONDA_PACKAGE   | conda package name                          |
| TOOL_CONDA_YAML      | YAML file defining environment              |

# YAML Support
The pipeline supports YAML-based environment specifications for tool installation.

YAML files are stored within the utils/ directory:
```text
dev/utils/<tool>.yaml
```

They are referenced via:
```bash
TOOL_CONDA_YAML="${UTILS_DIR}/<tool>.yaml"
```

This allows complex tool environments to be defined declaratively and consumed during installation.

# Role in the Pipeline
The `utils/` layer acts as the source of truth for tool definitions.

Its metadata is consumed by:
- installation layers in `functions/`
- validation stages in `preflight/`
- environment construction logic

By centralising tool definitions, the pipeline ensures that all downstream processes operate on consistent and standardised information.

# Declarative Design
The `utils/` directory is strictly declarative:
- it defines metadata, not behaviour
- it contains no executable logic
- it does not perform validation or installation

This ensures a clean separation between definition and implementation.

# Separation from Other Layers
The `utils/` layer does not overlap with other components:
- installation logic is handled in `functions/`
- validation occurs in `preflight/`
- execution is performed in `pipeline/`

This separation ensures maintainability and prevents duplication of responsibilities.

# Consistency and Standardisation
By enforcing a standard set of variables for all tools:
- tool integration becomes predictable
- downstream logic can operate generically
- new tools can be added without modifying core pipeline logic

This enables scalability and reuse across pipelines.

# Reproducibility
The declarative nature of the `utils/` layer contributes to reproducibility by:
- defining tools explicitly and consistently
- eliminating ambiguity in tool configuration
- ensuring that installation and execution operate from a shared definition

Given the same metadata definitions, tool behaviour remains consistent across environments.

# Summary
The `utils/` directory defines the metadata interface for all tools in the pipeline. By providing a declarative and logic-free layer, it enables consistent, modular, and reproducible tool integration across all stages of the workflow.