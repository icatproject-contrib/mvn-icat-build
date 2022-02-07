CONF_REPO = git@gitlab.helmholtz-berlin.de:icat/icat-config.git
LOCAL_USER = $(shell id -u)

install: build/apps build/src

build:
	sudo docker-compose pull
	sudo docker-compose build --pull

up: set-owner
	sudo docker-compose up -d

down:
	sudo docker-compose down -v

run: up
	sudo docker-compose exec build bash

set-owner:
	sudo chown -R '1000:1000' build/apps build/src

reset-owner:
	sudo chown -R $(LOCAL_USER) build/apps build/src

build/apps:
	git clone --branch site/hzb/testing/build $(CONF_REPO) $@
	$(MAKE) -C $@ unpack

build/src:
	mkdir $@

.PHONY: install build up down run set-owner reset-owner
