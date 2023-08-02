CONF_REPO = git@github.com:icatproject-contrib/icat-config.git
LOCAL_USER = $(shell id -u)

install: build/apps build/src

build: env
	sudo docker-compose pull
	sudo docker-compose build --pull

up: env cert set-owner
	sudo docker-compose up -d

down: env
	sudo docker-compose down -v
	bash -c '. .env && rm -rf $$BUILDHOME'

run: env up
	sudo docker-compose exec build bash

set-owner: cert
	sudo chown -R '1000:1000' build/apps build/src
	sudo chown -h '1000:1000' build/certs/*.pem

reset-owner: cert
	sudo chown -R $(LOCAL_USER) build/apps build/src
	sudo chown -h $(LOCAL_USER) build/certs/*.pem

env:
	bin/mkenv

cert: build/certs/cert.pem

build/certs/cert.pem:
	bin/mkcert

build/apps:
	git clone --branch testing/mvn-icat-build/payara4 $(CONF_REPO) $@
	$(MAKE) -C $@ unpack

build/src:
	mkdir $@

.PHONY: install build up down run set-owner reset-owner env cert
