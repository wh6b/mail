#!/usr/bin/bash
set -e

ADMIN="youruser"
ADMIN_DIR="/home/$ADMIN"
PROV="$ADMIN_DIR/deploy/provision"
TS=`date '+%Y%m%d'`

h1() {
    lenght=${#1}
    echo -e '\033[1;33m'
    printf "%${lenght}s\n" | tr " " "="
    echo $1
    printf "%${lenght}s" | tr " " "="
    echo -e '\033[0m'
}


h1 "Update Debian and install software"

apt update && apt upgrade -y
apt install -y fail2ban rsync podman slirp4netns python3-pip git zsh zsh-syntax-highlighting python3-pygments zsh-autosuggestions

sysctl -w "net.ipv4.ping_group_range=0 2000000"
sysctl -w "net.ipv4.ip_unprivileged_port_start=25"
cp -v local.conf /etc/sysctl.d/

timedatectl set-timezone Europe/Paris
grep -q LC_TIME /etc/default/locale || echo 'LC_TIME=en_US.UTF-8' >> /etc/default/locale


systemctl stop exim4.service
systemctl disable exim4.service

h1 "Disable f* IPV6" 
echo 'net.ipv6.conf.all.disable_ipv6 = 1' > /etc/sysctl.d/90-disable-ipv6.conf
sysctl -p -f /etc/sysctl.d/90-disable-ipv6.conf


h1 "Setup users"

mkdir -m 1777 /home/backup || echo ls -ld /home/backup

h1 "Configure fail2ban"
cp -v fail2ban/jail.local /etc/fail2ban/jail.d/
cp -v fail2ban/mydovecot.conf /etc/fail2ban/filter.d/
chown root:root /etc/fail2ban/filter.d/my* /etc/fail2ban/jail.d/*
chmod 640 /etc/fail2ban/filter.d/my* /etc/fail2ban/jail.d/*
fail2ban-client reload


h1 "Configure podman"
## lingering permit rootless containers continue working after user logout
loginctl enable-linger 1001

which fuse-overlayfs
echo /etc/subuid :
cat /etc/subuid 
echo /etc/subgid :
cat /etc/subgid
