#!/bin/bash
set -euo pipefail

# Nginx Proxy Manager → Traefik Migration Script
# Run this on the Arcane-managed Docker host

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== NPM → Traefik Migration ===${NC}"
echo ""

# ─── Step 0: Preflight checks ───
echo -e "${YELLOW}[0/6] Preflight checks...${NC}"

if [[ ! -f ".env" ]]; then
    echo -e "${RED}ERROR: .env file not found. Copy .env.example to .env and fill in your API keys.${NC}"
    exit 1
fi

source .env

if [[ -z "${PORKBUN_API_KEY:-}" || -z "${PORKBUN_SECRET_API_KEY:-}" ]]; then
    echo -e "${RED}ERROR: Porkbun API keys not set in .env${NC}"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: docker command not found${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Preflight passed${NC}"

# ─── Step 1: Backup NPM data ───
echo -e "${YELLOW}[1/6] Backing up NPM data...${NC}"
BACKUP_DIR="/var/data/nginx/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r /var/data/nginx/data "$BACKUP_DIR/"
cp -r /var/data/nginx/letsencrypt "$BACKUP_DIR/"
echo -e "${GREEN}✓ Backup saved to $BACKUP_DIR${NC}"

# ─── Step 2: Create Traefik directories ───
echo -e "${YELLOW}[2/6] Creating Traefik directories...${NC}"
mkdir -p /var/data/traefik/certs
chmod 600 /var/data/traefik/certs
echo -e "${GREEN}✓ Directories ready${NC}"

# ─── Step 3: Stop NPM ───
echo -e "${YELLOW}[3/6] Stopping Nginx Proxy Manager...${NC}"
# Stop the proxy project via Arcane CLI if available, otherwise docker compose
if command -v arcane-cli &> /dev/null; then
    arcane-cli projects down proxy || true
    arcane-cli projects destroy proxy || true
else
    cd /root/compose/proxy || true
    docker compose down || true
fi
echo -e "${GREEN}✓ NPM stopped${NC}"

# ─── Step 4: Deploy Traefik ───
echo -e "${YELLOW}[4/6] Deploying Traefik...${NC}"
cp docker-compose.yml /root/compose/proxy/docker-compose.yml
cp traefik.yml /var/data/traefik/traefik.yml
cp dynamic.yml /var/data/traefik/dynamic.yml

cd /root/compose/proxy || exit 1
docker compose up -d traefik

echo -e "${GREEN}✓ Traefik deployed${NC}"

# ─── Step 5: Verify ───
echo -e "${YELLOW}[5/6] Waiting for Traefik to start...${NC}"
sleep 5

if docker ps | grep -q traefik; then
    echo -e "${GREEN}✓ Traefik container is running${NC}"
else
    echo -e "${RED}✗ Traefik container is NOT running. Check logs:${NC}"
    docker logs traefik --tail 50
    exit 1
fi

# Check if ports are bound
if ss -tlnp | grep -q ':80\|:443'; then
    echo -e "${GREEN}✓ Ports 80/443 are bound${NC}"
else
    echo -e "${YELLOW}⚠ Ports 80/443 may not be bound yet${NC}"
fi

# ─── Step 6: Health check sample hosts ───
echo -e "${YELLOW}[6/6] Health check sample hosts...${NC}"
SAMPLE_HOSTS=(
    "https://arcane.tbs.amn.gg"
    "https://git.tbs.amn.gg"
    "https://grafana.tbs.amn.gg"
)

for host in "${SAMPLE_HOSTS[@]}"; do
    status=$(curl -o /dev/null -s -w "%{http_code}" "$host" || true)
    if [[ "$status" == "200" || "$status" == "302" || "$status" == "401" ]]; then
        echo -e "${GREEN}✓ $host → HTTP $status${NC}"
    else
        echo -e "${YELLOW}⚠ $host → HTTP $status (may need certificate provisioning)${NC}"
    fi
done

echo ""
echo -e "${GREEN}=== Migration Complete ===${NC}"
echo ""
echo "Traefik dashboard: https://nginx.tbs.amn.gg/dashboard/"
echo "Monitor certificate generation: docker logs -f traefik"
echo ""
echo "If anything breaks, rollback with:"
echo "  cd /root/compose/proxy && docker compose down"
echo "  # Restore NPM from backup: $BACKUP_DIR"
echo ""
