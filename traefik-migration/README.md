# NPM → Traefik Migration

Migration from **Nginx Proxy Manager** to **Traefik v3** for the Arcane-managed Docker host.

## What Changed

| | Before (NPM) | After (Traefik) |
|---|---|---|
| **Proxy** | jc21/nginx-proxy-manager | traefik:v3.3 |
| **Config** | Web UI + SQLite DB | `traefik.yml` + `dynamic.yml` |
| **SSL** | HTTP challenge | HTTP challenge (Let's Encrypt) |
| **Discovery** | Manual host entry per container | File provider (single `dynamic.yml`) |
| **Dashboard** | NPM UI on port 81 | Traefik dashboard on `nginx.tbs.amn.gg/dashboard/` |

## Migrated Hosts (18 active)

| Domain | Backend | Notes |
|---|---|---|
| `adguard.tbs.amn.gg` | `adguard-adguardhome-1:80` | |
| `alex.amn.gg` | `holyclaude:3001` | |
| `alex.tbs.amn.gg` | `holyclaude:3001` | |
| `amn.gg` | `chatserver-dendrite-1:8008/8006` | Matrix well-known paths |
| `arcane.tbs.amn.gg` | `arcane:3552` | |
| `bitwarden.amn.gg` | `bitwarden-bitwarden-1:80/3012` | WebSocket on `/notifications/hub` |
| `bitwarden.tbs.amn.gg` | `bitwarden-bitwarden-1:80/3012` | Alias |
| `bt.tbs.amn.gg` | `bitwarden-bitwarden-1:80/3012` | Alias |
| `git.tbs.amn.gg` | `forgejo:3000` | |
| `grafana.tbs.amn.gg` | `grafana:3000` | |
| `manclaude.tbs.amn.gg` | `manweholyclaude:3001` | |
| `matrix.amn.gg` | `chatserver-dendrite-1:8008/8006` | Matrix well-known paths |
| `maxun-api.tbs.amn.gg` | `172.16.81.175:8080` | External IP |
| `maxun.tbs.amn.gg` | `172.16.81.175:5173` | External IP |
| `metube.tbs.amn.gg` | `metube:8081` | |
| `stash.manwe.amn.gg` | `stash:9999` | |
| `stash.tbs.amn.gg` | `stash:9999` | |
| `warsmash.tbs.amn.gg` | `warsmash:80` | Container currently stopped |

## Archived Hosts (14 removed)

See `missing-hosts.json` for the full list of hosts whose backing containers no longer exist. These are **not included** in the Traefik config. If you restore any of these containers later, add them to `dynamic.yml`.

## Prerequisites

1. **Cloudflare API Token** — for `*.manko.yoga` (optional, pre-configured for future use)
2. **SSH access** to the Arcane Docker host

## Migration Steps

### 1. Copy configs to the server

```bash
scp -r traefik-migration/ root@your-arcane-host:/root/
ssh root@your-arcane-host
cd /root/traefik-migration
```

### 2. Configure environment

```bash
cp .env.example .env
# Edit .env and add your Cloudflare API token (optional, for future domains)
nano .env
```

### 3. Run the migration

```bash
./migrate.sh
```

This script will:
1. Verify API keys are set
2. Backup NPM data to `/var/data/nginx/backup-YYYYMMDD-HHMMSS/`
3. Create Traefik directories
4. **Stop and remove NPM**
5. Deploy Traefik on ports 80/443
6. Run health checks on sample hosts

### 4. Monitor certificate issuance

Traefik will request certificates via HTTP challenge:

```bash
docker logs -f traefik
```

Look for:
```
ACME CA=https://acme-v02.api.letsencrypt.org/directory
Testing certificate renew...
Certificate obtained successfully
```

First certificates are usually issued within 30–60 seconds.

### 5. Verify all hosts

```bash
# Quick check
curl -I https://arcane.tbs.amn.gg
curl -I https://git.tbs.amn.gg
curl -I https://grafana.tbs.amn.gg
curl -I https://bitwarden.tbs.amn.gg
```

## Rollback

If anything goes wrong:

```bash
# Stop Traefik
cd /root/compose/proxy && docker compose down

# Restore NPM
cp /var/data/nginx/backup-*/data/* /var/data/nginx/data/
cp /var/data/nginx/backup-*/letsencrypt/* /var/data/nginx/letsencrypt/

# Re-deploy NPM (restore original docker-compose.yml first)
# ... then start the proxy project via Arcane
```

## File Structure

```
traefik-migration/
├── docker-compose.yml      # Proxy project (Traefik + newt)
├── traefik.yml             # Traefik static config
├── dynamic.yml             # All 18 host routers & services
├── .env.example            # API key template
├── migrate.sh              # One-click migration script
├── missing-hosts.json      # Archive of 14 removed hosts
└── README.md               # This file
```

## Post-Migration

- **Traefik dashboard:** https://nginx.tbs.amn.gg/dashboard/
- **New container?** Add a router + service block to `dynamic.yml` — no container restart needed
- **SSL renewal:** Automatic via DNS challenge
- **Logs:** `docker logs -f traefik`
