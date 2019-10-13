FROM alpine:latest

RUN apk update && apk add openssl curl

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
