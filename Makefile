CONF_REPO = git@github.com:icatproject-contrib/icat-config.git
LOCAL_USER = $(shell id -u)

install: build/apps build/src

build: env cert
	sudo docker-compose pull
	sudo docker-compose build --pull

up: env set-owner
	sudo docker-compose up -d

down: env
	sudo docker-compose down -v
	bash -c '. .env && rm -rf $$BUILDHOME'

run: env up
	sudo docker-compose exec build bash

set-owner:
	sudo chown -R '1000:1000' build/apps build/src

reset-owner:
	sudo chown -R $(LOCAL_USER) build/apps build/src

env:
	bin/mkenv

cert: env build/image/certs/cert.pem

build/image/certs/cert.pem:
	bin/mkcert

build/apps:
	git clone --branch testing/mvn-icat-build/payara4 $(CONF_REPO) $@
	$(MAKE) -C $@ unpack

build/src:
	mkdir $@

.PHONY: install build up down run set-owner reset-owner env cert
