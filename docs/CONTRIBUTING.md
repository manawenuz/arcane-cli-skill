# Contributing

Thank you for considering contributing to the Arcane CLI Skill!

## How to Contribute

### Reporting Issues

If you find a bug or missing command:

1. Check if the issue already exists in [GitHub Issues](https://github.com/manawenuz/arcane-cli-skill/issues)
2. If not, open a new issue with:
   - A clear title
   - The `arcane-cli` version (`arcane --version`)
   - Expected vs actual behavior
   - Sample output if relevant

### Adding Commands

`arcane-cli` evolves over time. If new commands are added:

1. Fork the repository
2. Edit `arcane/SKILL.md` to add the new command(s)
3. Follow the existing format:
   - Command name in bold
   - Code block with usage
   - Brief description
   - Sample output if helpful
4. Update `docs/COMMANDS.md` with the full reference
5. Open a Pull Request

### Style Guide

- Use `arcane` as the primary command name (not `arcane-cli`)
- Keep descriptions concise but complete
- Use `<placeholder>` for required arguments
- Use `[optional]` for optional arguments
- Mark destructive commands clearly

### Testing

Before submitting:

1. Verify the skill file is valid Markdown
2. Check that all links work
3. Ensure commands match your local `arcane-cli` output

## Development Setup

```bash
git clone https://github.com/manawenuz/arcane-cli-skill.git
cd arcane-cli-skill

# Symlink for live testing
ln -s "$(pwd)/arcane" ~/.kimi/skills/arcane
```

## Code of Conduct

Be respectful and constructive. We're all here to make Docker management easier.
