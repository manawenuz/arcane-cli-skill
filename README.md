# Arcane CLI Skill

> Agent skill for managing Docker containers, projects, images, networks, and volumes via the [Arcane CLI](https://github.com/getarcaneapp/arcane).

[![Skill Registry](https://img.shields.io/badge/skills.sh-arcane--cli--skill-blue)](https://skills.sh)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Overview

This skill extends [Kimi Code CLI](https://moonshotai.github.io/kimi-cli/), [Claude Code](https://code.claude.com/), and compatible agents with deep knowledge of the **`arcane-cli`** command-line interface.

Instead of remembering every subcommand and flag, just ask your agent:

- *"List all running Arcane projects"*
- *"Restart the bitwarden project and check its status"*
- *"Pull latest images and redeploy forgejo"*
- *"Prune unused images, networks, and volumes"*
- *"Show me which containers are unhealthy"*

The agent will generate the correct `arcane` commands, run them, and interpret the output for you.

## What is Arcane?

[Arcane](https://github.com/getarcaneapp/arcane) is a modern Docker management platform that provides:

- Project-based container grouping (Docker Compose stacks)
- Multi-environment support (local + remote Arcane instances)
- Image registry management and update checking
- Template system for reusable Docker Compose configurations
- Admin features: API keys, users, events, notifications

## Quick Start

### Install via `npx skills`

```bash
npx skills add manawenuz/arcane-cli-skill@arcane -g -y
```

### Manual Install

Copy the `arcane/` directory into your agent's skills folder:

| Tool | Path |
|------|------|
| **Kimi CLI** | `~/.kimi/skills/arcane/SKILL.md` |
| **Claude Code** | `~/.claude/skills/arcane/SKILL.md` |
| **Codex** | `~/.codex/skills/arcane/SKILL.md` |
| **Generic** | `~/.config/agents/skills/arcane/SKILL.md` |

### Verify Installation

```bash
# Kimi CLI
kimi --version

# The skill loads automatically on next session startup.
# You can verify it is discovered by checking the skills scope in your prompt.
```

## Prerequisites

- [`arcane-cli`](https://github.com/getarcaneapp/arcane) installed and on your `$PATH`
- A valid `~/.config/arcanecli.yml` with server URL and authentication tokens
- At least one Arcane environment configured (default `0` is Local Docker)

Verify your setup:

```bash
arcane config test
arcane auth me
```

## Command Reference

### Projects

Projects group containers into logical stacks.

```bash
arcane projects list                    # List all projects
arcane projects get <name|id>           # Show project details
arcane projects up <name|id>            # Start project
arcane projects down <name|id>          # Stop project
arcane projects restart <name|id>       # Restart project
arcane projects pull <name|id>          # Pull latest images
arcane projects redeploy <name|id>      # Pull + restart
arcane projects destroy <name|id>       # Destroy project and containers
arcane projects counts                  # Summary counts
```

### Containers

```bash
arcane containers list                  # List containers
arcane containers list -a               # Include stopped
arcane containers get <name|id>         # Container details
arcane containers start <name|id>       # Start container
arcane containers stop <name|id>        # Stop container
arcane containers restart <name|id>     # Restart container
arcane containers delete <name|id>      # Delete container
arcane containers counts                # Running/stopped/total
```

### Images

```bash
arcane images list                      # List images
arcane images get <name|id>             # Image details
arcane images pull [NAME]               # Pull image
arcane images remove <name|id>          # Remove image
arcane images prune                     # Prune unused
arcane images updates check-all         # Check all for updates
arcane images updates summary           # Update summary
```

### Networks & Volumes

```bash
arcane networks list                    # List networks
arcane networks delete <name|id>        # Delete network
arcane networks prune                   # Prune unused

arcane volumes list                     # List volumes
arcane volumes sizes                    # Volume sizes
arcane volumes usage <name>             # Specific volume usage
arcane volumes delete <name>            # Delete volume
arcane volumes prune                    # Prune unused
```

### Templates

```bash
arcane templates list                   # Local templates
arcane templates all                    # All including remote
arcane templates content <id>           # Get compose content
arcane templates variables              # Template variables
arcane templates registries             # Template registries
```

### System & Admin

```bash
# System
arcane system containers-start-all      # Start everything
arcane system containers-stop-all       # Stop everything
arcane system prune                     # Global prune

# Admin
arcane admin api-keys list              # List API keys
arcane admin users list                 # List users
arcane admin events list                # List events
arcane admin notifications settings-get # Notification settings
```

### Environments

```bash
arcane environments list                # List environments
arcane environments switch              # Switch default (interactive)
arcane environments test <id>           # Test connection
```

## Common Workflows

### 1. Health Check Dashboard

```bash
arcane projects counts
arcane containers counts
arcane images updates summary
arcane containers list | grep unhealthy
```

### 2. Update & Redeploy a Project

```bash
arcane projects pull myapp
arcane projects redeploy myapp
arcane projects get myapp
```

### 3. Clean Up Unused Resources

```bash
arcane images prune
arcane volumes prune
arcane networks prune
# Or everything at once:
arcane system prune
```

### 4. Switch Environment & Inspect

```bash
arcane environments switch              # Pick remote interactively
arcane projects list
arcane containers list
```

## Known Limitations

### Pagination

`arcane-cli` list commands are paginated server-side (20 items per page). However, the CLI **does not expose `--page` or `--start` flags** for `containers list` or `projects list`, meaning items beyond the first page may be hidden.

```bash
# Check pagination metadata in JSON output
arcane containers list -a --json | jq '.pagination'
# { "totalPages": 2, "totalItems": 30, "currentPage": 1, "itemsPerPage": 20 }
```

**Workaround:** Use `docker` directly on the target host if you need to see all containers.

## Global Flags

| Flag | Description |
|------|-------------|
| `-c, --config <path>` | Custom config file (default `~/.config/arcanecli.yml`) |
| `--json` | Output as JSON for parsing |
| `--log-level <level>` | `debug` / `info` / `warn` / `error` / `fatal` / `panic` |

**Tip:** Use `--json` when you need the agent to programmatically extract IDs or statuses from output.

## File Structure

```
arcane-cli-skill/
├── arcane/
│   └── SKILL.md          # Skill definition consumed by the agent
├── README.md             # This file
├── LICENSE               # MIT License
└── docs/
    ├── INSTALL.md        # Detailed installation guide
    ├── COMMANDS.md       # Full command reference with examples
    └── TROUBLESHOOTING.md # Common issues and fixes
```

## Contributing

Contributions are welcome! If you find missing commands or outdated examples:

1. Fork the repository
2. Edit `arcane/SKILL.md`
3. Open a pull request

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for details.

## Related

- [Arcane App](https://github.com/getarcaneapp/arcane) — The Arcane Docker management platform
- [skills.sh](https://skills.sh) — Discover more agent skills

## License

[MIT](LICENSE) © Manwe
