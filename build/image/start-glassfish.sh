#!/bin/bash

domainname=domain1

DOMAINDIR=$GLASSFISH_HOME/glassfish/domains/$domainname
export DOMAINDIR


glassfish_init() {
    adminpw="$(pwgen -s 32 1)"
    pwfile=$(mktemp)
    echo "AS_ADMIN_PASSWORD=${adminpw}" > $pwfile
    asadmin --passwordfile $pwfile --user admin \
	create-domain --savelogin $domainname
    rm -f $pwfile
    ln -s /usr/share/java/mysql-connector-java.jar $DOMAINDIR/lib
    asadmin start-domain $domainname
    asadmin set server.http-service.access-log.format="common"
    asadmin set server.http-service.access-logging-enabled=true
    asadmin set server.thread-pools.thread-pool.http-thread-pool.max-thread-pool-size=128
    asadmin set server.ejb-container.property.disable-nonportable-jndi-names="true"
    asadmin set configs.config.server-config.network-config.protocols.protocol.http-listener-2.http.request-timeout-seconds=-1

    mkdir -p \
	$DOMAINDIR/data/icat \
	$DOMAINDIR/data/icat/lucene \
	$DOMAINDIR/data/ids \
	$DOMAINDIR/data/lucene
}

if [[ ! -d $DOMAINDIR ]]; then
    glassfish_init
else
    asadmin start-domain
fi
