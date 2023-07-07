#!/bin/ash
set -ex
echo Starting Entry point..

echo -e "Update unbound DNS list.."
wget -S https://www.internic.net/domain/named.cache -O /etc/unbound/root.hints
sleep 1

echo -e "Run redis server daemon.."
redis-server &

echo -e "Run unbound server daemon.."
unbound &

echo -e "Run rspamd daemon.."
rspamd -f -u rspamd -g rspamd

echo Entry point ended with sucess