# Installation Guide

## Requirements

- **Node.js 18+** (for `npx skills` install method)
- **Git** (for manual clone/install)
- **arcane-cli** installed and configured on your system

## Install arcane-cli

### macOS (Homebrew)

```bash
brew tap getarcaneapp/tap
brew install arcane-cli
```

### Linux

```bash
# Download latest release from GitHub
curl -L -o arcane-cli "https://github.com/getarcaneapp/arcane/releases/latest/download/arcane-cli-linux-amd64"
chmod +x arcane-cli
sudo mv arcane-cli /usr/local/bin/
```

### Verify Installation

```bash
arcane --version
arcane config test
```

## Install This Skill

### Method 1: Via `npx skills` (Recommended)

The [Skills CLI](https://skills.sh) is the package manager for agent skills.

```bash
npx skills add manawenuz/arcane-cli-skill@arcane -g -y
```

**What this does:**
- Downloads the skill from GitHub
- Installs it globally (user-level) in your agent's skills directory
- Makes it available across all projects

### Method 2: Manual Copy

1. Clone or download this repository:

```bash
git clone https://github.com/manawenuz/arcane-cli-skill.git
cd arcane-cli-skill
```

2. Copy the `arcane/` directory to your agent's skills folder:

**Kimi Code CLI:**
```bash
mkdir -p ~/.kimi/skills
cp -r arcane ~/.kimi/skills/
```

**Claude Code:**
```bash
mkdir -p ~/.claude/skills
cp -r arcane ~/.claude/skills/
```

**Generic / Cross-tool:**
```bash
mkdir -p ~/.config/agents/skills
cp -r arcane ~/.config/agents/skills/
```

### Method 3: Symlink (for Development)

If you want to work on the skill and see changes immediately:

```bash
git clone https://github.com/manawenuz/arcane-cli-skill.git
cd arcane-cli-skill
ln -s "$(pwd)/arcane" ~/.kimi/skills/arcane
```

## Verify the Skill is Loaded

### Kimi Code CLI

Start a new session and observe the system prompt. The skill should appear under the **User** scope as `arcane`.

```bash
kimi
# Then ask: "What skills do you have available?"
```

### Claude Code

```bash
claude
# Ask: "What skills are loaded?"
# Or check: /config
```

## Updating the Skill

### Via Skills CLI

```bash
npx skills check          # Check for updates
npx skills update         # Update all installed skills
```

### Manual Update

```bash
cd arcane-cli-skill
git pull
cp -r arcane/SKILL.md ~/.kimi/skills/arcane/SKILL.md
```

## Uninstalling

### Via Skills CLI

```bash
npx skills remove manawenuz/arcane-cli-skill@arcane
```

### Manual

```bash
rm -rf ~/.kimi/skills/arcane
# or
rm -rf ~/.claude/skills/arcane
```

## Troubleshooting Installation

### "Skill not found"

- Ensure the directory is named exactly `arcane/` and contains `SKILL.md`
- Check that the skills directory path matches your tool:
  - Kimi: `~/.kimi/skills/`
  - Claude: `~/.claude/skills/`
  - Generic: `~/.config/agents/skills/`

### "npx skills command not found"

Install the Skills CLI globally:

```bash
npm install -g skills
```

### "arcane-cli not found"

Ensure `arcane-cli` is on your `$PATH`:

```bash
which arcane-cli
# If empty, add the binary location to your PATH in ~/.bashrc or ~/.zshrc
```
