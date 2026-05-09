# Troubleshooting

Common issues when using the Arcane CLI skill.

## Skill Not Loading

### Symptom
The agent doesn't recognize Arcane commands or says it doesn't have the skill.

### Solutions

1. **Verify the skill is installed in the correct directory:**
   ```bash
   ls ~/.kimi/skills/arcane/SKILL.md    # Kimi CLI
   ls ~/.claude/skills/arcane/SKILL.md  # Claude Code
   ```

2. **Restart your agent session.** Skills are loaded at session startup.

3. **Check for naming conflicts.** Ensure the directory is exactly `arcane/` (lowercase) with `SKILL.md` inside.

## arcane-cli Connection Errors

### Symptom
Commands fail with connection or authentication errors.

### Solutions

1. **Test the connection:**
   ```bash
   arcane config test
   ```

2. **Check your config:**
   ```bash
   arcane config show
   ```
   Verify the `Server URL` is correct and the `JWT Token` is present.

3. **Re-authenticate:**
   ```bash
   arcane auth login
   ```

4. **Refresh the token:**
   ```bash
   arcane auth refresh
   ```

5. **Check if the Arcane server is running:**
   ```bash
   curl -I https://your-arcane-server/health
   ```

## Wrong Environment

### Symptom
Commands affect the wrong server or show unexpected data.

### Solution

Check and switch environments:

```bash
arcane environments list
arcane environments switch
```

The default environment ID `0` is usually "Local Docker". Remote environments have UUIDs.

## Command Not Found

### Symptom
`arcane: command not found`

### Solutions

1. **Verify installation:**
   ```bash
   which arcane-cli
   which arcane
   ```

2. **Check your PATH:**
   ```bash
   echo $PATH
   ```

3. **Reinstall arcane-cli** following the [official instructions](https://github.com/getarcaneapp/arcane).

## JSON Parsing Issues

### Symptom
The agent struggles to parse command output.

### Solution

Always add `--json` to commands when the agent needs to extract specific values:

```bash
arcane projects list --json
arcane containers list --json
```

## Large Output Truncation

### Symptom
Output is cut off when listing many containers or images.

### Solutions

1. **Use pagination flags:**
   ```bash
   arcane containers list -n 20
   arcane images list --start 0 --limit 20
   ```

2. **Filter with search:**
   ```bash
   arcane images list --search nginx
   arcane containers list | grep myapp
   ```

3. **Use counts for overview:**
   ```bash
   arcane projects counts
   arcane containers counts
   ```

## Permission Denied

### Symptom
`403 Forbidden` or `Unauthorized` errors.

### Solutions

1. **Check your token hasn't expired:**
   ```bash
   arcane auth me
   ```

2. **Verify you have the required role.** Admin commands require admin privileges.

3. **Regenerate API keys** if using API key auth:
   ```bash
   arcane admin api-keys create my-new-key
   ```

## Container Stuck in Restart Loop

### Symptom
Container status shows `restarting` or `unhealthy`.

### Diagnostic Commands

```bash
# Get detailed container info
arcane containers get <name>

# Check container logs (if available via Docker directly)
docker logs <container-id>

# Restart the project
arcane projects restart <project-name>
```

## Image Update Check Fails

### Symptom
`arcane images updates check-all` errors out.

### Solutions

1. **Check registry connectivity:**
   ```bash
   arcane registries list
   arcane registries test <registry-id>
   ```

2. **Sync registries:**
   ```bash
   arcane registries sync
   ```

3. **Verify the image tag is valid** and the registry is accessible from the Arcane server.

## Getting Help

If you're stuck:

1. Check the [Arcane GitHub repository](https://github.com/getarcaneapp/arcane)
2. Run `arcane <command> --help` for any subcommand
3. Open an issue on [this skill's repository](https://github.com/manawenuz/arcane-cli-skill/issues)
