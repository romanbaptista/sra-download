# `functions/`

# Purpose
The `functions/` directory provides reusable implementation logic for tool installation and handling within the pipeline.

It is structured into two complementary layers:
- generic installation functions
- tool-specific functions

This separation ensures that installation logic is modular, reusable, and independent of runtime execution.

# Structure
The directory is divided into distinct functional layers:

- **Generic layers**  
  Provide shared functionality for acquiring and preparing tools.

- **tool-specific layers**  
  Implement logic required for individual tools.

These layers work together to standardise how tools are installed and prepared for use.

# Generic Installation Layers

### Tarball Layer
The tarball layer, implemented in `functions_tarball.sh`, provides generalised functionality for handling archive-based installations.

Its responsibilities include:
- downloading archive files
- extracting archive contents
- performing basic cleanup of temporary files

This layer is intentionally minimal and does not interpret or modify tool-specific structures.

| Tarball Layer Responsibility | Description                          |
|-----------------------------|--------------------------------------|
| Download                    | retrieves archive files              |
| Extract                     | unpacks archive contents             |
| Cleanup                     | removes temporary installation files |
| Excludes                    | no restructuring or validation       |

# Conda Layer
The conda layer, implemented in `functions_conda.sh`, provides functionality for acquiring tools via temporary Conda environments.

Its responsibilities include:
- creating temporary environments
- installing required packages
- constructing environments from YAML specifications

These environments exist only during installation and are removed afterwards.

| Conda Layer Responsibility | Description                              |
|---------------------------|------------------------------------------|
| Environment creation      | creates temporary conda environments     |
| Package installation      | installs required packages               |
| YAML support              | builds environments from specifications  |
| Lifecycle                 | environments are deleted after use       |

# Tool-Specific Layer
Tool-specific functions define how individual tools are installed and validated.

Each tool must provide its own implementation layer, typically in `functions_<tool>.sh`.

These scripts define the interface between generic installation logic and tool-specific requirements.

| Tool-Specific Function | Role                                  |
|----------------------|---------------------------------------|
| `check_<tool>()`       | validates tool binary and availability |
| `install_<tool>()`     | installs and prepares the tool         |

# Separation of Responsibilities
The `functions/` directory enforces strict separation between layers:
- generic functions handle common tasks
- tool-specific functions handle tool structure and validation
- runtime execution is handled elsewhere

This prevents duplication and ensures that installation logic remains consistent across tools.

# Key Principles
- installation logic is modular and reusable
- generic layers never implement tool-specific behaviour
- tool-specific layers extend generic functionality without modifying it
- runtime execution is fully separated from installation

This design ensures clarity and maintainability across the pipeline.

# Role in the Pipeline
The `functions/` layer operates exclusively during preflight:
- it supports tool installation and preparation
- it contributes to generating deterministic runtime environments
- it does not participate in execution-stage processing

By confining all installation logic to preflight, the pipeline achieves a clean separation between setup and execution.

# Reproducibility
The separation of installation and execution ensures reproducibility:
- tools are installed deterministically
- runtime environments are constructed independently
- execution does not depend on installation state

This guarantees consistent behaviour across systems and runs.

# Summary
The `functions/` directory provides the reusable implementation layer for tool installation. By separating generic functionality from tool-specific logic, and isolating installation from runtime execution, it ensures a modular, consistent, and reproducible tool integration model.