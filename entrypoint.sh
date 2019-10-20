#!/bin/sh

set -e

######## Check for required/optional inputs. ########

# Determine whether using a Global API Key or a restricted API Token.
if [ -n "$CLOUDFLARE_KEY" ]; then
  # If they've passed a key, the account email address is also required.
  if [ -n "$CLOUDFLARE_EMAIL" ]; then
    API_METHOD=1
  else
    echo "CLOUDFLARE_EMAIL is required when using a Global API Key. Quitting."
    exit 1
  fi

# No key was entered, check if they're using a token.
elif [ -n "$CLOUDFLARE_TOKEN" ]; then
  API_METHOD=2

# The user hasn't entered either a key or a token, can't do anything else.
else
  echo "Looks like you haven't set the required authentication variables."
  echo "Check out the README for options: https://git.io/JeBbD"
  exit 1
fi


# Check if Zone ID is set.
if [ -z "$CLOUDFLARE_ZONE" ]; then
  echo "CLOUDFLARE_ZONE is not set. Quitting."
  exit 1
fi

# If URL array is passed, only purge those. Otherwise, purge everything.
if [ -n "$PURGE_URLS" ]; then
  set -- --data '{"files":'"${PURGE_URLS}"'}'
else
  set -- --data '{"purge_everything":true}'
fi


######## Call the API and store the response for later. ########

# Using a global API key:
if [ "$API_METHOD" -eq 1 ]; then
  HTTP_RESPONSE=$(curl -sS "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/purge_cache" \
                      -H "Content-Type: application/json" \
                      -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
                      -H "X-Auth-Key: ${CLOUDFLARE_KEY}" \
                      -w "HTTP_STATUS:%{http_code}" \
                      "$@")

# Using an API token:
elif [ "$API_METHOD" -eq 2 ]; then
  HTTP_RESPONSE=$(curl -sS "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE}/purge_cache" \
                      -H "Content-Type: application/json" \
                      -H "Authorization: Bearer ${CLOUDFLARE_TOKEN}" \
                      -w "HTTP_STATUS:%{http_code}" \
                      "$@")
fi


######## Format response for a pretty command line output. ########

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
