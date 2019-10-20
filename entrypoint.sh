#!/bin/sh

set -e

if [ -z "$INPUT_CLOUDFLAREZONE" ]; then
  echo "cloudflareZone is not set. Quitting."
  exit 1
fi

if [ -z "$INPUT_CLOUDFLAREEMAIL" ]; then
  echo "cloudflareEmail is not set. Quitting."
  exit 1
fi

if [ -z "$INPUT_CLOUDFLAREKEY" ]; then
  echo "cloudflareKey is not set. Quitting."
  exit 1
fi

# If URL array is passed, only purge those. Otherwise, purge everything.
if [ -n "$INPUT_PURGEURLS" ]; then
  set -- --data '{"files":'"${INPUT_PURGEURLS}"'}'
else
  set -- --data '{"purge_everything":true}'
fi

# Call the API and store the response for later.
HTTP_RESPONSE=$(curl -sS -X POST "https://api.cloudflare.com/client/v4/zones/${INPUT_CLOUDFLAREZONE}/purge_cache" \
                     -H "X-Auth-Email: ${INPUT_CLOUDFLAREEMAIL}" \
                     -H "X-Auth-Key: ${INPUT_CLOUDFLAREKEY}" \
                     -H "Content-Type: application/json" \
                     -w "HTTP_STATUS:%{http_code}" \
                     "$@")

# Store result and HTTP status code separately to appropriately throw CI errors.
# https://gist.github.com/maxcnunes/9f77afdc32df354883df
HTTP_BODY=$(echo "${HTTP_RESPONSE}" | sed -E 's/HTTP_STATUS\:[0-9]{3}$//')
HTTP_STATUS=$(echo "${HTTP_RESPONSE}" | tr -d '\n' | sed -E 's/.*HTTP_STATUS:([0-9]{3})$/\1/')

# Fail pipeline and print errors if API doesn't return an OK status.
if [ "${HTTP_STATUS}" -eq "200" ]; then
  echo "Successfully purged!"
  exit 0
else
  echo "Purge failed. API response was: "
  echo "${HTTP_BODY}"
  exit 1
fi
