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

# Call the API and store the response for later.
HTTP_RESPONSE=$(curl -sS -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/purge_cache" \
         -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
         -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
         -H "Content-Type: application/json" \
         --data ${DATA_ARG} \
         --write-out "HTTP_STATUS:%{http_code}")

# Store result and HTTP status code separately to appropriately throw CI errors.
# https://gist.github.com/maxcnunes/9f77afdc32df354883df
HTTP_BODY=$(echo $HTTP_RESPONSE | sed -E 's/HTTP_STATUS\:[0-9]{3}$//')
HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -E 's/.*HTTP_STATUS:([0-9]{3})$/\1/')

# Fail pipeline and print errors if API doesn't return an OK status.
if [ $HTTP_STATUS -eq "200" ]; then
  echo "Successfully purged!"
  exit 0
else
  echo "Purge failed. API response was:"
  echo $HTTP_BODY
  exit 1
fi
