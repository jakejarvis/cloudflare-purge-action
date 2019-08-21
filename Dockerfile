FROM alpine:3.10

LABEL "com.github.actions.name"="Purge Cloudflare Cache"
LABEL "com.github.actions.description"="Purge a zone's cache via the Cloudflare API"
LABEL "com.github.actions.icon"="trash-2"
LABEL "com.github.actions.color"="orange"

LABEL version="0.1.0"
LABEL "repository"="https://github.com/jakejarvis/cloudflare-purge-action"
LABEL "homepage"="https://jarv.is/"
LABEL "maintainer"="Jake Jarvis <jake@jarv.is>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
