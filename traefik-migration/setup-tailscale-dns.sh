#!/bin/bash
set -euo pipefail

# Setup Tailscale DNS records in Porkbun
# Run this AFTER updating .env with your Porkbun credentials

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TAILSCALE_IP="100.79.87.65"

echo -e "${GREEN}=== Tailscale DNS Setup ===${NC}"
echo ""

if [[ ! -f ".env" ]]; then
    echo -e "${RED}ERROR: .env file not found.${NC}"
    exit 1
fi

source .env

if [[ -z "${PORKBUN_API_KEY:-}" || -z "${PORKBUN_SECRET_API_KEY:-}" ]]; then
    echo -e "${RED}ERROR: Porkbun API keys not set in .env${NC}"
    exit 1
fi

# ─── Create A record for manwehs.tailscale.amn.gg ───
echo -e "${YELLOW}[1/2] Creating A record: manwehs.tailscale.amn.gg → ${TAILSCALE_IP}${NC}"

curl -s -X POST "https://api.porkbun.com/api/json/v3/dns/create/amn.gg" \
  -H "Content-Type: application/json" \
  -d "{
    \"secretapikey\": \"${PORKBUN_SECRET_API_KEY}\",
    \"apikey\": \"${PORKBUN_API_KEY}\",
    \"name\": \"manwehs.tailscale\",
    \"type\": \"A\",
    \"content\": \"${TAILSCALE_IP}\",
    \"ttl\": \"600\"
  }" | jq -r '[.status, .id] | @tsv'

# ─── Create CNAME records for all services ───
echo ""
echo -e "${YELLOW}[2/2] Creating CNAME records pointing to manwehs.tailscale.amn.gg...${NC}"

SERVICES=(
  "traefik"
  "adguard"
  "amn"
  "arcane"
  "bitwarden"
  "git"
  "grafana"
  "matrix"
  "maxun-api"
  "maxun"
  "metube"
  "stash"
  "stash-manwe"
  "warsmash"
)

for svc in "${SERVICES[@]}"; do
  echo -n "  ${svc}.tailscale.amn.gg ... "
  
  resp=$(curl -s -X POST "https://api.porkbun.com/api/json/v3/dns/create/amn.gg" \
    -H "Content-Type: application/json" \
    -d "{
      \"secretapikey\": \"${PORKBUN_SECRET_API_KEY}\",
      \"apikey\": \"${PORKBUN_API_KEY}\",
      \"name\": \"${svc}.tailscale\",
      \"type\": \"CNAME\",
      \"content\": \"manwehs.tailscale.amn.gg\",
      \"ttl\": \"600\"
    }")
  
  status=$(echo "$resp" | jq -r '.status // "UNKNOWN"')
  
  if [[ "$status" == "SUCCESS" ]]; then
    echo -e "${GREEN}✓${NC}"
  elif echo "$resp" | grep -q "already exists"; then
    echo -e "${YELLOW}exists${NC}"
  else
    echo -e "${RED}✗ ($status)${NC}"
    echo "    $resp" | jq -r '.message // .status'
  fi
done

echo ""
echo -e "${GREEN}=== Done ===${NC}"
echo ""
echo "Verify with:"
echo "  dig manwehs.tailscale.amn.gg"
echo "  dig git.tailscale.amn.gg"
echo ""
