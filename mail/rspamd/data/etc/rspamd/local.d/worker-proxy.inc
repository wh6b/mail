# /etc/rspamd/local.d/worker-proxy.inc
milter = no;
bind_socket = *:11332;
upstream "scan" {
default = yes; # Self-scan upstreams are always default
self_scan = yes; # Enable self-scan
#hosts = "*:11333";
}

upstream "local" {
  self_scan = yes; # Enable self-scan
}

# Proxy worker is listening on *:11332 by default
#bind_socket = localhost:11332;
