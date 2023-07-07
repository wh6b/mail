#!/bin/ash
set -ex
echo Starting Entry point..

echo Configure users
/usr/sbin/setup-users.sh

/usr/sbin/dovecot #-c /etc/dovecot/mydovecot.conf

#/usr/sbin/exim -bd -q 30m || ash
/usr/sbin/exim -bd -qq2m

echo Entry point ended with sucess