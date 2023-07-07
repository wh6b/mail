# mail
Exim, dovecot, clamav, rspamd, letsencrypt, nginx with rootless podman (2 pods)

(Work in progress)

Install repo where you want

## Install and setup podman and cie
Adapt if necessary and launch
```./bootstrap.sh```

## Customize config files
names, paths and filenames, etc.
- `./https/proxy/Makefile`
- `./https/proxy/Dockerfile`
- `-./mail/exim/Makefile`
- `./mail/exim/Dockerfile`

- `./https/proxy/data/nginx/sites/wh6b.conf`
- `./https/proxy/data/nginx/sites/wh6b.www.conf`
- `./https/proxy/data/nginx/sites/wh6b.rspamd.conf`
- `./https/proxy/data/nginx/nginx.conf`
- `./https/proxy/data/nginx/users.def`

## Mail accounts
Create your email users profiles (system user on exim+dovecot container
`./mail/exim/data/sbin/setup-users.sh`

## Non-letsencrypt certificates
From exim, dovecot and nginx manuals generate these certificates
- `./mail/exim/data/exim/dkim.key`
- `./mail/exim/data/exim/dkim.pem`
- `./mail/exim/data/dovecot/dh.pem`
- `./https/proxy/data/nginx/ssl/dhparam.pem`


## SPF, DKIM
Configure your DNS entries to validate SPF,DKIM

## Letsencrypt certificates
Adapt names, domains, paths, on `./https/letsencrypt/Makefile`
```
cd https/letsencrypt/
make build
make deploy
```
`make deploy` must install certificates in :
- `./mail/exim/data/exim/`
- `./mail/exim/data/dovecot/`
- `./https/proxy/data/nginx/ssl/`


## Create pods
```
./mail/pod_mail
./https/pod_https
```

## Run containers
```
cd https/proxy && make run
cd -
cd mail/exim && make run
cd -
cd mail/clamav && make run
cd -
cd mail/rpsamd && make run
```
## Configure systemd services to stop and start pods
```
su - youruser -c podman pod start https 
su - youruser -c podman pod start email 
```

------------------------

Peristant data is in volumes inside `data` directories

`make save` to backup data

`make update` to delete and rerun containers

