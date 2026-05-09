---
name: arcane
description: Manage Docker containers, projects, images, networks, and volumes via the Arcane CLI (getarcaneapp/arcane). Covers projects, containers, images, templates, environments, registries, system operations, and admin tasks.
---

# Arcane CLI Skill

## Overview

Arcane is a modern Docker management platform with a CLI (`arcane-cli` or `arcane`) that provides comprehensive container, image, network, volume, project, and template management. Use this skill when the user wants to manage Docker resources through Arcane.

**Binary names:** `arcane-cli` or `arcane` (synonymous)
**Config file:** `~/.config/arcanecli.yml`
**Default output:** Human-readable tables; use `--json` for structured output

## Configuration

The CLI stores server URL, tokens, and default environment in `~/.config/arcanecli.yml`.

```bash
# View current config
arcane config show

# Test API connection
arcane config test

# Print config file path
arcane config path
```

**Environments** are remote Arcane instances. The default environment (ID `0`) is usually "Local Docker".

```bash
# List environments
arcane environments list

# Switch default environment (interactive)
arcane environments switch

# Test a specific environment
arcane environments test <id>
```

## Authentication

```bash
# Login via OIDC device authorization
arcane auth login

# Get current user
arcane auth me

# Refresh token
arcane auth refresh

# Change password
arcane auth password

# Logout
arcane auth logout
```

## Projects

Projects are logical groupings of containers (typically Docker Compose stacks).

```bash
# List projects
arcane projects list
arcane projects list --json
arcane projects list -n 50

# Get project counts
arcane projects counts

# Get project details
arcane projects get <project-id|name>

# Lifecycle
arcane projects up <project-id|name>       # Start
arcane projects down <project-id|name>     # Stop
arcane projects restart <project-id|name>  # Restart
arcane projects pull <project-id|name>     # Pull latest images
arcane projects redeploy <project-id|name> # Pull + restart

# Destroy project and all its containers
arcane projects destroy <project-id|name>
```

**Sample `projects list` output:**
```
ID                                    NAME        STATUS   SERVICES  RUNNING  CREATED
48eb202f-f84b-4a1a-a905-a0b4f761ff10  stash       stopped  1         0        2026-02-14T16:34:36Z
3be0da9b-8753-40e7-ab9b-5d359dbffe48  arcane      running  1         1        2026-02-14T16:37:26Z
ae23e8ee-f28c-42ea-b386-013755cb5c85  forgejo     running  4         4        2026-04-02T05:14:48Z
```

## Containers

```bash
# List containers
arcane containers list
arcane containers list --json
arcane containers list -a               # Include stopped

# Get container counts
arcane containers counts

# Get container details
arcane containers get <container-id|name>

# Lifecycle
arcane containers start <container-id|name>
arcane containers stop <container-id|name>
arcane containers restart <container-id|name>

# Delete a container
arcane containers delete <container-id|name>

# Update a container
arcane containers update <container-id|name>
```

**Sample `containers list` output:**
```
ID            NAME                   IMAGE                                STATE    STATUS
ca6fe6d6332c  kiro-gateway           kiro-gateway-kiro-gateway            running  Up 6 hours (healthy)
195dd60e14b7  mikrotail-bridge       mikrotail-rs:dev                     exited   Exited (137) 2 weeks ago
```

## Images

```bash
# List images
arcane images list
arcane images list --json
arcane images list --search nginx
arcane images list --sort size --order desc

# Get image counts
arcane images counts

# Get image details
arcane images get <image-id|name>

# Pull an image
arcane images pull [IMAGE_NAME]

# Remove an image
arcane images remove <image-id|name>

# Prune unused images
arcane images prune

# Upload from tar archive
arcane images upload [FILE]
```

**Image updates:**
```bash
# Check for updates
arcane images updates check
arcane images updates check-all
arcane images updates check-image <image-id>
arcane images updates summary
```

**Sample `images list` output:**
```
ID                                                                       REPOSITORY:TAG                SIZE    IN USE
sha256:a7cf8fb7b72c8984b2eb1ac301afa8b01eaf77bf49bd69e86fa57dfcea03b317  kiro-gateway-kiro-gateway:latest  362.5M  Yes
```

## Networks

```bash
# List networks
arcane networks list

# Get network counts
arcane networks counts

# Get network details
arcane networks get <network-id|name>

# Delete a network
arcane networks delete <network-id|name>

# Prune unused networks
arcane networks prune
```

## Volumes

```bash
# List volumes
arcane volumes list

# Get volume counts
arcane volumes counts

# Get volume details
arcane volumes get <volume-name>

# Get volume sizes
arcane volumes sizes

# Get specific volume usage
arcane volumes usage <volume-name>

# Delete a volume
arcane volumes delete <volume-name>

# Prune unused volumes
arcane volumes prune
```

## Templates

Templates are Docker Compose templates managed by Arcane.

```bash
# List local templates
arcane templates list

# List all templates (including remote)
arcane templates all

# Get default templates
arcane templates default

# Get template content
arcane templates content <template-id>

# Get template variables
arcane templates variables

# Delete a template
arcane templates delete <template-id>

# List template registries
arcane templates registries

# Delete a template registry
arcane templates delete-registry <registry-id>
```

## Container Registries

```bash
# List registries
arcane registries list

# Sync registries
arcane registries sync

# Test registry connection
arcane registries test <registry-id>

# Delete a registry
arcane registries delete <registry-id>
```

## System Operations

```bash
# Start all containers
arcane system containers-start-all

# Stop all containers
arcane system containers-stop-all

# Get Docker daemon info
arcane system docker-info

# Prune all unused resources (containers, networks, images, volumes)
arcane system prune
```

## Background Jobs

```bash
# Get job schedule intervals
arcane jobs get

# Update job schedule intervals
arcane jobs update
```

## Settings

```bash
# List environment settings
arcane settings list
```

## Admin

### API Keys
```bash
arcane admin api-keys list
arcane admin api-keys get <id>
arcane admin api-keys create <name>
arcane admin api-keys delete <id>
```

### Users
```bash
arcane admin users list
arcane admin users delete <user-id>
```

### Events
```bash
arcane admin events list
arcane admin events list-env
arcane admin events delete <event-id>
```

### Notifications
```bash
arcane admin notifications settings-get
arcane admin notifications apprise-get
```

## Updater

```bash
# Get updater status
arcane updater status

# Run updater
arcane updater run

# Get updater history
arcane updater history
```

## Version

```bash
# Get server version
arcane version
```

## Global Flags

These flags work with almost any command:

- `-c, --config <path>` — Path to config file (default: `~/.config/arcanecli.yml`)
- `--json` — Output in JSON format
- `--log-level <level>` — Log level: `debug`, `info`, `warn`, `error`, `fatal`, `panic`

## Common Workflows

### Restart a project and verify
```bash
arcane projects restart forgejo
arcane projects get forgejo
arcane containers list | grep forgejo
```

### Clean up unused resources
```bash
arcane images prune
arcane volumes prune
arcane networks prune
# Or prune everything at once:
arcane system prune
```

### Check overall health
```bash
arcane projects counts
arcane containers counts
arcane images updates summary
```

### Pull latest images and redeploy a project
```bash
arcane projects pull myapp
arcane projects redeploy myapp
```

### Switch to a remote environment and list projects
```bash
arcane environments switch
# Select environment interactively, then:
arcane projects list
```

## Pagination Behavior

`arcane-cli` list commands are paginated server-side (20 items per page). Use `--start` to fetch subsequent pages:

```bash
# Page 1 (default)
arcane containers list --json

# Page 2
arcane containers list --start 20 --json

# Check pagination metadata
arcane containers list --json | jq '.pagination'
# {
#   "totalPages": 2,
#   "totalItems": 30,
#   "currentPage": 1,
#   "itemsPerPage": 20
# }
```

**Note:** `--all` cannot be combined with `--start` in some versions. Use `--start` with the default (running) list and filter client-side if needed.

## Tips for Agent Usage

1. **Prefer `--json` for programmatic parsing** when you need to extract specific IDs or statuses.
2. **Use names over IDs** when possible — Arcane accepts either.
3. **Check counts first** when doing bulk operations to understand the scope.
4. **Be careful with `destroy` and `prune`** — these are destructive operations.
5. **Always verify the active environment** before making changes on remote servers (`arcane environments list`).
6. **For image updates**, run `arcane images updates check-all` before deciding what to pull.
7. **Remember pagination** — if a container or project seems missing from `list` output, it may be on page 2. Use `counts` or `get <name>` to verify.
