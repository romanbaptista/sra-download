# `installs/`

# Purpose
The `installs/` directory stores all installed tool binaries used by the pipeline.

Each tool is installed into its own dedicated directory, ensuring isolation and consistency across tools. This directory acts as the canonical location for all executable binaries required during pipeline execution.

# Required Structure
All tools must conform to a uniform directory layout:
```text
installs/<tool>/bin/<binary>
```

This structure ensures that every tool exposes its executable through a consistent and predictable interface, regardless of how it was installed.

# Key Principle
The install layer produces a uniform interface across all tools.

Regardless of the installation method used (e.g. archive extraction or environment-based installation), all tools must be normalised into the same directory structure.

This guarantees that tools can be located and used consistently without relying on installation-specific details.

# Execution Role
Execution modules rely exclusively on binaries located within the `installs/` directory.

All tool execution is performed using these binaries, eliminating any dependency on:
- external system installations
- pre-configured environments
- system-wide `PATH` settings

This ensures that the pipeline remains self-contained and portable across different systems.

# Standardised Layout

| Path Structure            | Description                            |
|--------------------------|----------------------------------------|
| `installs/<tool>/  `       | tool-specific installation directory   |
| `installs/<tool>/bin/`     | contains executable binaries           |
| `installs/<tool>/bin/<binary>` | canonical executable used at runtime |

# Rules
- Only required binaries are retained
- Temporary installation files must be removed after installation
- Directory structure must be validated during installation
- All tools must expose their executable within a bin/ directory

These rules enforce consistency and prevent unintended variability in tool behaviour.

# Consistency Across Tools
By enforcing a standardised layout:
- all tools are accessed in the same way
- execution logic remains tool-agnostic
- differences in installation methods are completely abstracted

This allows execution modules to operate without needing to know how tools were originally installed.

# Reproducibility
The `installs/` directory contributes directly to reproducibility by:
- providing a deterministic location for all binaries
- ensuring that tool resolution does not depend on system configuration
- maintaining consistent directory structures across runs

Given the same inputs and installation process, the structure and contents of this directory will be identical across environments.

# Summary
The `installs/` directory provides a standardised, deterministic interface for all tool binaries. By enforcing a consistent layout and isolating tools from the host environment, it ensures reliable and reproducible execution across pipeline stages.