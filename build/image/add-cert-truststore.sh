#! /bin/bash
# Helper: add a certificate in PEM format to a Java keystore in pkcs12 format.

keystore=$1
cert=$2
alias=$3

fp=$(openssl x509 -in $cert -noout -sha256 -fingerprint | cut -d '=' -f 2 -s)
if ! (keytool -list -keystore $keystore -storetype pkcs12 -storepass changeit \
	  | grep -q $fp)
then
    echo "Import $cert to $keystore"
    tmpfile=`mktemp`
    openssl x509 -in $cert -outform der -out $tmpfile
    keytool -import -file $tmpfile -alias $alias \
	    -keystore $keystore -storetype pkcs12 \
	    -storepass changeit \
	    -noprompt
    rm -f $tmpfile
fi
