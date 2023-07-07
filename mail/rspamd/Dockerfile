# syntax=docker/dockerfile:1
FROM alpine:edge
LABEL org.opencontainers.image.authors="Nicolas Vergnes"
LABEL org.opencontainers.image.email="nicov@wh6b.org"
LABEL org.opencontainers.image.version=1
LABEL org.opencontainers.image.name="spam"

RUN apk update && apk upgrade  \
 && apk add --no-cache -v tzdata rspamd rspamd rspamd-controller rspamd-proxy rspamd-client rspamd-fuzzy rspamd-utils redis unbound gnupg ca-certificates musl musl-utils  \
 && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime  \
 && echo "Europe/Paris" > /etc/timezone  \
 && echo "#### UNBOUND DNS ####"  \
 && echo "nameserver 127.0.0.1" > /etc/resolv.conf  \
 && cp /etc/unbound/unbound.conf /etc/unbound/unbound.conf.ori  \
 && echo "#### REDIS ####"  \
 && echo "maxmemory 200mb" >> /etc/redis.conf  \
 && chgrp root /var/log/* /var/lib/* && chmod 750 /var/log/* \
 && chown rspamd /var/lib/rspamd  \
 && rm -fr /var/cache/apk/*

RUN sed -i  \
  -e 's,# verbosity: 1,verbosity: 1,'  \
  -e 's,# interface: e.*,interface: 0.0.0.0,'  \
  -e 's,# do-ip4:.*,do-ip4: yes,'  \
  -e 's,# do-ip6:.*,do-ip6: no,'  \
  -e 's,# access-control: ::f.*,access-control: 0.0.0.0/0 allow,'  \
  -e 's,# do-tcp:.*,do-tcp: yes,'  \
  -e 's,# do-udp:.*,do-udp: yes,'  \
  -e 's,# do-daemonize:.*,do-daemonize: yes,'  \
  -e 's,# log-queries:.*,log-queries: yes,'  \
  -e 's,# hide-identity:.*,hide-identity: yes,'  \
  -e 's,# hide-version:.*,hide-version: yes,'  \
  -e 's,# use-syslog:.*,use-syslog: no,'  \
  -e 's,# logfile:.*,logfile: /var/log/unbound/unbound.log,'  \
  -e 's,.*control-enable: yes,  control-enable: no,'  \
  -e 's,control-interface: /run/unbound.control.sock,# control-interface: /run/unbound.control.sock,'  \
  -e 's,^# Forward zones,# Forward zones\nforward-zone:\n  name: "."\n  ## Level3 Verizon\n  forward-addr: 4.2.2.1\n  forward-addr: 4.2.2.4,'  \
  /etc/unbound/unbound.conf

RUN tar cvfz /rspamd.tgz /etc/rspamd

COPY data/etc/rspamd /etc/rspamd/
COPY data/sbin/entrypoint.sh /usr/sbin/


RUN sed -i -e 's,bind_socket = "localhost:11334",bind_socket = "0.0.0.0:11334",' /etc/rspamd/rspamd.conf


# Not using rspamd-fuzzy for now
RUN sed -i '/fuzzy/,$d' /etc/rspamd/rspamd.conf

VOLUME ["/var/log","/var/lib"]

EXPOSE 11333/tcp 11334/tcp

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
