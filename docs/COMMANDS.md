# Complete Command Reference

Complete reference for all `arcane-cli` commands covered by this skill.

## Table of Contents

- [Global Flags](#global-flags)
- [Projects](#projects)
- [Containers](#containers)
- [Images](#images)
- [Networks](#networks)
- [Volumes](#volumes)
- [Templates](#templates)
- [Registries](#registries)
- [Environments](#environments)
- [System](#system)
- [Admin](#admin)
- [Auth](#auth)
- [Jobs](#jobs)
- [Settings](#settings)
- [Updater](#updater)
- [Config](#config)

---

## Global Flags

These work with almost every command:

| Flag | Short | Description |
|------|-------|-------------|
| `--config` | `-c` | Path to config file (default: `~/.config/arcanecli.yml`) |
| `--json` | | Output in JSON format |
| `--log-level` | | Log level: `debug`, `info`, `warn`, `error`, `fatal`, `panic` |
| `--help` | `-h` | Show help for command |
| `--version` | `-v` | Print version |

---

## Projects

Projects are logical groupings of containers, usually corresponding to Docker Compose stacks.

### `arcane projects list`

List all projects.

```bash
arcane projects list
arcane projects list --json
arcane projects list -n 50          # Limit to 50
```

**Output:**
```
ID                                    NAME        STATUS   SERVICES  RUNNING  CREATED
48eb202f-f84b-4a1a-a905-a0b4f761ff10  stash       stopped  1         0        2026-02-14T16:34:36Z
ae23e8ee-f28c-42ea-b386-013755cb5c85  forgejo     running  4         4        2026-04-02T05:14:48Z
```

### `arcane projects counts`

Get summary counts.

```bash
arcane projects counts
```

**Output:**
```
Project Counts
runningProjects: 6
stoppedProjects: 8
totalProjects: 15
```

### `arcane projects get <id|name>`

Show project details.

```bash
arcane projects get forgejo
arcane projects get ae23e8ee-f28c-42ea-b386-013755cb5c85
```

**Output:**
```
Project Details
ID: ae23e8ee-f28c-42ea-b386-013755cb5c85
Name: forgejo
Status: running
Services: 4
Running: 4
```

### `arcane projects up <id|name>`

Start a stopped project.

```bash
arcane projects up stash
```

### `arcane projects down <id|name>`

Stop a running project.

```bash
arcane projects down stash
```

### `arcane projects restart <id|name>`

Restart a project.

```bash
arcane projects restart forgejo
```

### `arcane projects pull <id|name>`

Pull latest images for a project without restarting.

```bash
arcane projects pull bitwarden
```

### `arcane projects redeploy <id|name>`

Pull latest images **and** restart the project.

```bash
arcane projects redeploy loandashboard
```

### `arcane projects destroy <id|name>`

**DESTRUCTIVE**: Remove the project and all its containers.

```bash
arcane projects destroy bwtest
```

---

## Containers

### `arcane containers list`

```bash
arcane containers list
arcane containers list -a               # Include stopped containers
arcane containers list --json
arcane containers list -n 50
```

**Output:**
```
ID            NAME                   IMAGE                                STATE    STATUS
ca6fe6d6332c  kiro-gateway           kiro-gateway-kiro-gateway            running  Up 6 hours (healthy)
195dd60e14b7  mikrotail-bridge       mikrotail-rs:dev                     exited   Exited (137) 2 weeks ago
```

**Pagination:** Returns 20 items per page. Use `--start 20` for page 2, `--start 40` for page 3, etc. Check `.pagination` in `--json` output for totals.

### `arcane containers counts`

```bash
arcane containers counts
```

**Output:**
```
Container Status Counts
Running: 31
Stopped: 5
Total: 36
```

### `arcane containers get <id|name>`

```bash
arcane containers get arcane
```

**Output:**
```
Container Details
ID: 834ac0d00a86f1139b3e2b70d3237ea07e55ef36942a8de03f645be21f967bf5
Name: arcane
Image: ghcr.io/getarcaneapp/arcane:latest
State: running (Running: true)
Created: 2026-04-28T02:59:03.460224877Z
```

### Lifecycle Commands

```bash
arcane containers start <id|name>
arcane containers stop <id|name>
arcane containers restart <id|name>
arcane containers delete <id|name>       # Remove container
arcane containers update <id|name>       # Update container configuration
```

---

## Images

### `arcane images list`

```bash
arcane images list
arcane images list --json
arcane images list --search nginx
arcane images list --sort size --order desc
arcane images list --start 20 --limit 20   # Pagination
```

**Output:**
```
ID                                                                       REPOSITORY:TAG                SIZE    IN USE
sha256:a7cf8fb7b72c8984b2eb1ac301afa8b01eaf77bf49bd69e86fa57dfcea03b317  kiro-gateway-kiro-gateway:latest  362.5M  Yes
```

### `arcane images counts`

```bash
arcane images counts
```

### Image Operations

```bash
arcane images get <id|name>              # Details
arcane images pull [IMAGE_NAME]          # Pull from registry
arcane images remove <id|name>           # Remove image
arcane images prune                      # Prune unused
arcane images upload [FILE]              # Upload from tar archive
```

### Image Updates

```bash
arcane images updates check              # Check for updates
arcane images updates check-all          # Check all images
arcane images updates check-image <id>   # Check specific image
arcane images updates summary            # Summary of available updates
```

---

## Networks

```bash
arcane networks list                     # List networks
arcane networks counts                   # Usage counts
arcane networks get <id|name>            # Details
arcane networks delete <id|name>         # Delete network
arcane networks prune                    # Prune unused
```

**Output:**
```
ID            NAME                  DRIVER  SCOPE  CREATED
2be26d408770  public                bridge  local  2025-12-05 10:39
```

---

## Volumes

```bash
arcane volumes list                      # List volumes
arcane volumes counts                    # Usage counts
arcane volumes get <name>                # Details
arcane volumes sizes                     # All volume sizes
arcane volumes usage <name>              # Specific volume usage
arcane volumes delete <name>             # Delete volume
arcane volumes prune                     # Prune unused
```

**Output:**
```
NAME          DRIVER  MOUNTPOINT                                    CREATED
compose_tailscaled_state  local  /var/lib/docker/volumes/...  2026-04-19T17:25:33Z
```

---

## Templates

Templates are reusable Docker Compose configurations.

```bash
arcane templates list                    # Local templates
arcane templates all                     # All including remote
arcane templates default                 # Default templates
arcane templates content <id>            # Get compose file content
arcane templates variables               # Global template variables
arcane templates registries              # List registries
arcane templates delete <id>             # Delete template
arcane templates delete-registry <id>    # Delete registry
```

---

## Registries

Container image registries configured in Arcane.

```bash
arcane registries list                   # List registries
arcane registries sync                   # Sync registry metadata
arcane registries test <id>              # Test connection
arcane registries delete <id>            # Delete registry
```

---

## Environments

Arcane supports multiple environments (local + remote instances).

```bash
arcane environments list                 # List environments
arcane environments get <id>             # Get details
arcane environments test <id>            # Test connection
arcane environments delete <id>          # Delete environment
arcane environments switch               # Interactive switch
```

**Output:**
```
ID                                    NAME          API URL                   STATUS   ENABLED
0                                     Local Docker  http://localhost:3552     online   true
f4f7456c-539d-44bd-a060-1ef919e542f6  manNas        http://172.16.81.137:3553 online   true
```

---

## System

```bash
arcane system containers-start-all       # Start ALL containers
arcane system containers-stop-all        # Stop ALL containers
arcane system docker-info                # Docker daemon info
arcane system prune                      # Prune ALL unused resources
```

---

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

---

## Auth

```bash
arcane auth login                        # OIDC device auth login
arcane auth logout                       # Clear tokens
arcane auth me                           # Current user info
arcane auth refresh                      # Refresh JWT token
arcane auth password                     # Change password
```

---

## Jobs

Background job schedules.

```bash
arcane jobs get                          # Show schedule intervals
arcane jobs update                       # Update schedule intervals
```

---

## Settings

```bash
arcane settings list                     # List environment settings
```

---

## Updater

```bash
arcane updater status                    # Updater status
arcane updater run                       # Run updater now
arcane updater history                   # Update history
```

---

## Config

```bash
arcane config show                       # Show current config
arcane config test                       # Test API connection
arcane config path                       # Print config file path
arcane config set <key> <value>          # Set config value
```

---

## Version

```bash
arcane version                           # Server version info
```
