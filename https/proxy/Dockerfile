# syntax=docker/dockerfile:1
FROM alpine:edge
LABEL org.opencontainers.image.authors="Nicolas Vergnes"
LABEL org.opencontainers.image.email="nicov@wh6b.org"
LABEL org.opencontainers.image.name="proxy"
LABEL org.opencontainers.image.version=2

RUN apk update && apk upgrade  \
 && apk add --no-cache -v nginx tzdata  \
 && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime  \
 && echo "Europe/Paris" > /etc/timezone  \
 && rm -fr /var/cache/apk/*

VOLUME ["/etc/nginx","/var/log"]

#EXPOSE 80/tcp 443/tcp
EXPOSE 443/tcp

ENTRYPOINT ["/usr/sbin/nginx"]
