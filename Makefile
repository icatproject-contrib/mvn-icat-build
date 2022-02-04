CONF_REPO = git@github.com:icatproject-contrib/icat-config.git
LOCAL_USER = $(shell id -u)

install: build/apps build/src

build:
	sudo docker-compose pull
	sudo docker-compose build --pull

run: set-owner
	sudo docker-compose run --rm build

down:
	sudo docker-compose down -v

set-owner:
	sudo chown -R '1000:1000' build/apps build/src

reset-owner:
	sudo chown -R $(LOCAL_USER) build/apps build/src

build/apps:
	git clone $(CONF_REPO) $@
	$(MAKE) -C $@ unpack

build/src:
	mkdir $@

.PHONY: install build run down set-owner reset-owner
