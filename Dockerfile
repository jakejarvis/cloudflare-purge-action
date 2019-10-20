FROM curlimages/curl@sha256:4c7b687d607d7f5f397db1ca877a626fedc79c7a537a3f145482083bd68dc115

LABEL "com.github.actions.name"="Cloudflare Purge Cache"
LABEL "com.github.actions.description"="Purge a zone's cache via the Cloudflare API"
LABEL "com.github.actions.icon"="trash-2"
LABEL "com.github.actions.color"="orange"

LABEL version="0.3.0"
LABEL repository="https://github.com/jakejarvis/cloudflare-purge-action"
LABEL homepage="https://jarv.is/"
LABEL maintainer="Jake Jarvis <jake@jarv.is>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
