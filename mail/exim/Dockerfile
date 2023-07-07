# syntax=docker/dockerfile:1
FROM alpine:edge
LABEL org.opencontainers.image.authors="Nicolas Vergnes"
LABEL org.opencontainers.image.email="nicov@wh6b.org"
LABEL org.opencontainers.image.version=5
LABEL org.opencontainers.image.name="exim"

RUN apk update && apk upgrade  \
 && apk add --no-cache -v tzdata exim dovecot dovecot-lmtpd  \
 && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime  \
 && echo "Europe/Paris" > /etc/timezone  \
 && addgroup dovecot mail  \
 && chgrp mail /var/log /var/mail  \
 && chmod 2775 /var/mail

COPY data/exim/* /etc/exim/
COPY data/dovecot/* /etc/dovecot/
COPY data/sbin/* /usr/sbin/

#### CONFIGURE EXIM ####
RUN cd /etc/exim  \
 && chmod 444 /etc/exim/*  \
 && cp exim.conf exim.ori  \
 && sed -i  \
   -e 's,^domainlist local_domains = @$,domainlist local_domains = yoursite.org,'  \
   -e 's,^domainlist relay_to_domains =$,domainlist relay_to_domains = yoursite.org,'  \
   -e 's,^# tls_certificate = /etc/ssl/cert.crt,tls_certificate = /etc/exim/yoursite.pem,'  \
   -e 's,^# tls_privatekey = /etc/ssl/cert.pem,tls_privatekey = /etc/exim/yoursite.key\ntls_dhparam = /etc/dovecot/dh.pem,'  \
   -e 's,^# daemon_smtp_ports = 25 : 465 : 587,daemon_smtp_ports = 25 : 465 : 587,'  \
   -e 's,^# tls_on_connect_ports = 465,tls_on_connect_ports = 465\nlog_file_path = /var/log/%slog,'  \
   -e 's,^file = /var/mail/$local_part_data,directory = $home/Maildir,'  \
   -e 's,transport = local_delivery,transport = dovecot_lmtp,'  \
   -e 's,^  driver = autoreply,  driver = autoreply\n\ndovecot_lmtp:\n  driver = lmtp\n  socket = /var/run/dovecot/lmtp\n  batch_max = 200\n  timeout = 2m\n  #allow suffixes/prefixes (default unset)\n  rcpt_include_affixes = true,' \
   -e 's,^localuser:,localuser:\n  debug_print = "R: local_user for $local_part@$domain"\n  domains = +local_domains,'  \
   -e 's,^begin authenticators,begin authenticators\n\ndovecot_login:\n  driver = dovecot\n  public_name = LOGIN\n  server_socket = /var/run/dovecot/auth-client\n# setting server_set_id might break several headers in mails sent by authenticated smtp. So be careful.\n  server_set_id = $auth1\n\ndovecot_plain:\n  driver = dovecot\n  public_name = PLAIN\n  server_socket = /var/run/dovecot/auth-client\n  server_set_id = $auth1,'  \
   -e 's,driver = smtp,driver = smtp\n  dkim_domain = ${lc:${domain:$h_from:}}\n  dkim_selector = 20200321\n  dkim_private_key = /etc/exim/dkim.key\n  dkim_canon = relaxed,'  \
   -e 's,driver = smtp,driver = smtp\n  message_size_limit = ${if > {$max_received_linelength}{998} {1}{0}},'  \
   exim.conf  \
 && sed -i  \
   -e 's,# spamd_address = 127.0.0.1 11333 variant=rspamd,spamd_address = 127.0.0.1 11333 variant=rspamd,'  \
   -e 's,# av_scanner = clamd:/run/clamav/clamd.sock,av_scanner = clamd:127.0.0.1 3310,'  \
   -e 's, # deny    malware    = ,deny    malware    = ,'  \
   -e 's,#         message    = This message contains a virus,       message    = This message contains a virus,'  \
   -e 's,# warn    spam       = nobody,warn    spam       = nobody,'  \
   -e 's,#         add_header = X-Spam,        add_header = X-Spam,'  \
   -e 's,#                      X-Spam,                     X-Spam,'  \
   exim.conf


#### CONFIGURE DOVECOT ####
RUN sed -i  \
    -e 's,^#protocols = imap,protocols = imap lmtp,'  \
    -e 's,^#listen = \*.*,listen = *,'  \
    -e 's,^#base_dir = /var/run/dovecot/,base_dir = /var/run/dovecot/,'  \
    -e 's,^#login_greeting = Dovecot ready.,login_greeting = Dovecot ready.,'  \
    -e 's,^#verbose_proctitle = no,verbose_proctitle = no,'  \
    -e 's,^#shutdown_clients = yes,shutdown_clients = yes,'  \
    -e 's,^!include_try /usr/share,#!include_try /usr/share,'  \
  /etc/dovecot/dovecot.conf

RUN sed -i  \
    -e 's,^protocol lmtp {,protocol lmtp {\n  # use %n to strip away the domain part\n  auth_username_format = %n\n  info_log_path = /var/log/dovecot-lmtp.log,'  \
  /etc/dovecot/conf.d/10-director.conf

RUN sed -i  \
    -e 's,^auth_mechanisms = plain,auth_mechanisms = plain login,'  \
    -e 's,^#disable_plaintext_auth = yes,disable_plaintext_auth = yes,'  \
    -e 's,^#auth_username_chars =,auth_username_chars =,'  \
    -e 's,^!include auth-passwdfile.conf.ext,#!include auth-passwdfile.conf.ext,'  \
    -e 's,^#!include auth-system.conf.ext,!include auth-system.conf.yoursite,'  \
  /etc/dovecot/conf.d/10-auth.conf

RUN sed -i  \
    -e 's,^#log_path = syslog,log_path = /var/log/dovecot.log,'  \
    -e 's,^#debug_log_path = ,debug_log_path = /var/log/dovecot-debug.log,'  \
    -e 's,^#auth_verbose = no,auth_verbose = yes,'  \
    -e 's,^#auth_verbose_passwords = no",auth_verbose_passwords = no,'  \
    -e 's,^#auth_debug = no,auth_debug = no,'  \
    -e 's,^#verbose_ssl = no,verbose_ssl = no,'  \
  /etc/dovecot/conf.d/10-logging.conf
  
RUN sed -i  \
    -e 's,^#mail_location = ,mail_location = maildir:/var/mail/%d/%u,'  \
    -e 's,^#mail_access_groups =,#mail_access_groups = root mail,'  \
  /etc/dovecot/conf.d/10-mail.conf

RUN sed -i  \
    -e 's,^#port = 993\n    #ssl = yes,    port = 993\n    ssl = yes,'  \
    -e 's,^service lmtp {,service lmtp {\n  executable = lmtp -L\n  process_min_avail = 3,'  \
    -e 's,  unix_listener auth-userdb {,  unix_listener auth-client {\n    mode = 0660\n    user = exim\n  }  \n  unix_listener auth-userdb {,'  \
  /etc/dovecot/conf.d/10-master.conf

RUN sed -i  \
    -e 's,^ssl_cert = </etc/ssl/dovecot/server.pem,ssl_cert = </etc/exim/yoursite.pem,'  \
    -e 's,^ssl_key = </etc/ssl/dovecot/server.key,ssl_key = </etc/exim/yoursite.key,'  \
    -e 's,^#ssl_dh = </etc/dovecot/dh.pem,ssl_dh = </etc/dovecot/dh.pem,'  \
  /etc/dovecot/conf.d/10-ssl.conf

RUN echo -e 'passdb {\n  driver = shadow\n}\n\nuserdb {\n  driver = passwd\n}' > /etc/dovecot/conf.d/auth-system.conf.yoursite


RUN rm -fr /var/cache/apk/*

VOLUME ["/var/log","/var/mail","/home","/backup"]

EXPOSE 25/tcp 465/tcp 587/tcp 993/tcp

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
