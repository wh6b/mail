## Nicolas Vergnes (wh6b.org)

DATADIR=$(CURDIR)/data
NAME=proxy
VERSION="`cat Dockerfile| grep "org.opencontainers.image.version" | cut -d"=" -f2 | egrep ".+" || echo no`"
CNAME=$(NAME)_$(VERSION)
IMG=nicolas/$(NAME):$(VERSION)
IMGSLUG=nicolas-$(NAME)-$(VERSION)
SAVE=/home/backup/node_$(IMGSLUG).save.$(shell date "+%y%m%d%H%M%S").tgz

.PHONY: clean shell rm start stop update

build:
	@echo ========BUILD IMAGE========
	podman pod exists https
	podman build -t $(IMG) --rm=true .
	echo $(IMG) > $@

run: build
	@echo ========RUN CONTAINER========
	podman run -d  \
	-v $(DATADIR)/nginx:/etc/nginx  \
	-v $(DATADIR)/log:/var/log/nginx  \
	--pod https --name=$(NAME) -it $(IMG)


clean:
	@echo ========DELETE IMAGE========
	podman rmi $(IMG) && rm build

shell:
	podman exec -it $(NAME) ash

rm:
	@echo ========DELETE CONTAINER========
	podman rm -f $(NAME)

logs:
	podman logs -f $(NAME)

start:
	@echo ========START CONTAINER========
	podman start $(NAME)

stop:
	podman stop $(NAME)

update: rm clean build run

save:
	tar cvfz $(SAVE) --exclude=build .
	@echo Docker image \"$(IMG)\" configuration and data saved in $(SAVE)

test:
	@echo Not implemented

default: build

