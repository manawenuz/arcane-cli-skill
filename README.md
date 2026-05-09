# Arcane CLI Skill for Kimi Code / Claude Code

An agent skill for managing Docker containers, projects, images, networks, and volumes via the [Arcane CLI](https://github.com/getarcaneapp/arcane) (`arcane-cli`).

## What is Arcane?

Arcane is a modern Docker management platform. This skill teaches your AI agent how to use the `arcane-cli` command-line tool to inspect and manage Docker resources through Arcane's API.

## Installation

### Via `npx skills` (recommended)

```bash
npx skills add <your-github-username>/arcane-cli-skill@arcane -g -y
```

### Manual installation

Copy the `arcane/` directory into your agent's skills folder:

- **Kimi CLI:** `~/.kimi/skills/arcane/SKILL.md`
- **Claude Code:** `~/.claude/skills/arcane/SKILL.md`
- **Generic:** `~/.config/agents/skills/arcane/SKILL.md`

## Usage

Once installed, the agent will automatically use this skill when you ask things like:

- "List my Arcane projects"
- "Restart the forgejo project"
- "Show me running containers"
- "Prune unused images and volumes"
- "Check for image updates"

## Covered Commands

- **Projects:** `list`, `get`, `up`, `down`, `restart`, `pull`, `redeploy`, `destroy`, `counts`
- **Containers:** `list`, `get`, `start`, `stop`, `restart`, `delete`, `update`, `counts`
- **Images:** `list`, `get`, `pull`, `remove`, `prune`, `updates check/check-all/summary`
- **Networks:** `list`, `get`, `delete`, `prune`, `counts`
- **Volumes:** `list`, `get`, `sizes`, `usage`, `delete`, `prune`, `counts`
- **Templates:** `list`, `all`, `default`, `content`, `variables`, `registries`
- **Environments:** `list`, `switch`, `test`
- **Registries:** `list`, `sync`, `test`
- **System:** `containers-start-all`, `containers-stop-all`, `docker-info`, `prune`
- **Admin:** `api-keys`, `users`, `events`, `notifications`
- **Auth:** `login`, `logout`, `me`, `refresh`
- **Jobs, Settings, Updater, Version**

## Requirements

- `arcane-cli` installed and configured (`~/.config/arcanecli.yml`)
- Access to an Arcane server (local or remote)

## License

MIT
