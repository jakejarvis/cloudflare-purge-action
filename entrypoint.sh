#!/bin/sh -l

set -e

if [ -z "$CLOUDFLARE_ZONE" ]; then
  echo "CLOUDFLARE_ZONE is not set. Quitting."
  exit 1
fi

if [ -z "$CLOUDFLARE_EMAIL" ]; then
  echo "CLOUDFLARE_EMAIL is not set. Quitting."
  exit 1
fi

if [ -z "$CLOUDFLARE_KEY" ]; then
  echo "CLOUDFLARE_KEY is not set. Quitting."
  exit 1
fi

curl -sS -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/purge_cache" \
     -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
     -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'
