CONF_REPO = git@github.com:icatproject-contrib/icat-config.git

install: build/apps build/src

build: env cert
	sudo docker-compose pull
	sudo docker-compose build --pull

up: env
	sudo docker-compose up -d

down: env
	sudo docker-compose down -v
	bash -c '. .env && rm -rf $$BUILDHOME'

run: env up
	sudo docker-compose exec build bash

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

.PHONY: install build up down run env cert
