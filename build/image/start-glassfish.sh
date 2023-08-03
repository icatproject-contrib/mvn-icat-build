#!/bin/bash

certsdir=$GLASSFISH_HOME/certs
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
    if [ -d $certsdir ]; then
	# The certs directory is present, e.g. it has been added by a
	# bind mount.  It contains the SSL certificate we should use.
	# Add the certificate to Glassfish's keystore, overwriting the
	# self-signed certificate that Glassfish created during
	# create-domain.
	tmpfile=`mktemp`
	# Remove the self-signed certificate from Glassfish's cacerts.jks.
	keytool -delete -alias s1as \
		-keystore $DOMAINDIR/config/cacerts.jks -storetype jks \
		-storepass changeit \
		-noprompt
	add-cert-truststore.sh \
	    $DOMAINDIR/config/cacerts.jks $certsdir/rootcert.pem local-payara
	echo "Import cert.pem to keystore.jks"
	if [ -f $certsdir/certchain.pem ]; then
	    openssl pkcs12 -export -chain \
		-in $certsdir/cert.pem -inkey $certsdir/key.pem \
		-CAfile $certsdir/certchain.pem \
		-out $tmpfile -name s1as -passout pass:changeit
	else
	    openssl pkcs12 -export \
		-in $certsdir/cert.pem -inkey $certsdir/key.pem \
		-out $tmpfile -name s1as -passout pass:changeit
	fi
	keytool -importkeystore \
	    -srckeystore $tmpfile -srcstoretype pkcs12 \
	    -srcstorepass changeit \
	    -destkeystore $DOMAINDIR/config/keystore.jks -deststoretype jks \
	    -deststorepass changeit \
	    -noprompt
	rm -f $tmpfile
    fi
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
	$DOMAINDIR/data/ids/archive \
	$DOMAINDIR/data/ids/cache \
	$DOMAINDIR/data/ids/main \
	$DOMAINDIR/data/lucene
}

if [[ ! -d $DOMAINDIR ]]; then
    glassfish_init
else
    asadmin start-domain
fi
