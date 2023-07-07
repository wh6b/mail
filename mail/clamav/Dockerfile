# syntax=docker/dockerfile:1
FROM alpine:edge
LABEL org.opencontainers.image.authors="Nicolas Vergnes"
LABEL org.opencontainers.image.email="nicov@wh6b.org"
LABEL org.opencontainers.image.version=1
LABEL org.opencontainers.image.name="clam"

RUN apk update && apk upgrade  \
 && apk add --no-cache -v tzdata clamav clamav-daemon clamav-libunrar  \
 && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime  \
 && echo "Europe/Paris" > /etc/timezone  \
 && mv /etc/clamav/clamd.conf /etc/clamav/clamd.conf.ori  \
 && mv /etc/clamav/freshclam.conf /etc/clamav/freshclam.conf.ori  \
 && chmod 770 /var/lib/clamav && chown clamav /var/lib/clamav  \
 && mkdir /run/clamav/ && chown clamav /run/clamav/  \
 && touch /var/log/clamav/clamav.log && chmod 640 /var/log/clamav/clamav.log && chgrp root /var/log/clamav/clamav.log  \
 && rm -fr /var/cache/apk/*
 
COPY data/etc/* /etc/clamav/
COPY data/sbin/entrypoint.sh /usr/sbin/

VOLUME ["/var/log","/var/lib/clamav"]

EXPOSE 3310/tcp

USER clamav

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
