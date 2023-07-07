## Nicolas Vergnes (wh6b.org)

DATADIR=$(CURDIR)/data
NAME=exim
VERSION="`cat Dockerfile| grep "org.opencontainers.image.version" | cut -d"=" -f2 | egrep ".+" || echo no`"
CNAME=$(NAME)_$(VERSION)
IMG=nicolas/$(NAME):$(VERSION)
IMGSLUG=nicolas-$(NAME)-$(VERSION)
SAVE=/home/backup/node_$(IMGSLUG).save.$(shell date "+%y%m%d%H%M%S").tgz

.PHONY: clean  shell  rm  start stop  update

build:
	@echo ========BUILD IMAGE========
	cp -p /home/debian/var/yoursite.* data/exim/
	podman pod exists mail
	podman build -t $(IMG) --rm=true .
	echo $(IMG) > $@

run: build
	@echo ========RUN CONTAINER========
	podman run -d  \
	-v $(DATADIR)/log:/var/log/  \
	-v $(DATADIR)/../../../emails/home:/home  \
	-v $(DATADIR)/mail:/var/mail:Z  \
	-v $(DATADIR)/backup:/backup  \
	--pod mail --name=$(CNAME) -it $(IMG)

clean:
	@echo ========DELETE IMAGE========
	podman rmi $(IMG) && rm build

shell:
	podman exec -it $(CNAME) ash

rm:
	@echo ========DELETE CONTAINER========
	podman rm -f $(CNAME)

logs:
	podman logs -f $(CNAME)

start:
	@echo ========START CONTAINER========
	podman start $(CNAME)
stop:
	podman stop $(CNAME)

update: rm clean build run

save:
	podman exec -it $(CNAME) tar cvfz /backup/emails.save.tgz /var/mail/
	tar cvfz $(SAVE) --exclude=build --exclude=data/mail .
	@echo Docker image \"$(IMG)\" configuration and data saved in $(SAVE)

test:
	@echo Not implemented

default: build
