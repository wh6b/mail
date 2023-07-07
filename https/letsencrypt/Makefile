## Nicolas Vergnes (wh6b.org)

DATADIR=$(CURDIR)/data
NAME=letsencrypt
VERSION="`cat Dockerfile| grep "org.opencontainers.image.version" | cut -d"=" -f2 | egrep ".+" || echo no`"
CNAME=$(NAME)_$(VERSION)
IMG=nicolas/$(NAME):$(VERSION)
IMGSLUG=nicolas-$(NAME)-$(VERSION)
SAVE=/home/backup/node_$(IMGSLUG).save.$(shell date "+%y%m%d%H%M%S").tgz

.PHONY: build save test

build:
	@echo ========BUILD AND RUN CONTAINER========
	podman run --rm -it -p 80:80/tcp  \
	-v "$(DATADIR)/etc:/etc/letsencrypt:Z"  \
	-v "$(DATADIR)/var:/var/lib/letsencrypt:Z"  \
	docker.io/certbot/certbot certonly  \
	--standalone --preferred-challenges http --non-interactive --agree-tos  --email nicov@yoursite.org  \
	-d yoursite.org -d www.yoursite.org -d mail.yoursite.org -d game.yoursite.org  $*

deploy:
	@echo ========DELIVER CERTIFICATES TO REPOSITORY========
	cp -L $(DATADIR)/etc/live/yoursite.org/fullchain.pem $(DATADIR)/ssl/yoursite.pem
	cp -L $(DATADIR)/etc/live/yoursite.org/privkey.pem $(DATADIR)/ssl/yoursite.key
	cp -p data/ssl/yoursite.* ../proxy/data/nginx/ssl/
	cp -p data/ssl/yoursite.pem /home/youruser/var/cert.pem
	cp -p data/ssl/yoursite.key /home/youruser/var/cert.key

save:
	tar cvfz $(SAVE) --exclude=build .
	@echo Docker image \"$(IMG)\" configuration and data saved in $(SAVE)

test:
	@echo ========TEST CONTAINER========
	make build --dry-run

default: build

