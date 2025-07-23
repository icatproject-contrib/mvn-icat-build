FROM rkrahl/opensuse:15.5

RUN zypper --non-interactive refresh

# For some reason not yet fully understood, a recent update of
# mysql-connector-java seem to break things.  (Incompatibility with
# Jave 11?)  Pin the package to the last known working version.
RUN zypper --non-interactive install \
	acl \
	git \
	glibc-locale \
	java-11-openjdk-devel \
	less \
	mariadb-client \
	maven \
	'mysql-connector-java < 8.4.0' \
	openssh \
	unzip && \
    zypper --non-interactive addlock mysql-connector-java

ARG uid
ARG gid

ENV GLASSFISH_HOME /opt/payara6
ENV JAVA_HOME /usr/lib64/jvm/java-11-openjdk
ENV LC_ALL en_US.UTF-8

RUN groupadd -g $gid -o abuild && \
    useradd -u $uid -g $gid -c "Build user" -d /home/abuild abuild && \
    mkdir -p \
	/home/abuild \
	/opt/payara6 \
	/opt/payara6/bin \
	/opt/payara6/test/data/ids/archive \
	/opt/payara6/test/data/ids/cache \
	/opt/payara6/test/data/ids/main

COPY add-cert-truststore.sh /usr/local/bin/
COPY certs /opt/payara6/certs
COPY start-glassfish.sh /opt/payara6/bin
COPY add-test-accounts.sh /opt/payara6/bin

RUN chmod 0755 \
	/usr/local/bin/add-cert-truststore.sh \
	/opt/payara6/bin/add-test-accounts.sh \
	/opt/payara6/bin/start-glassfish.sh && \
    chown -R abuild:abuild /home/abuild /opt/payara6 && \
    add-cert-truststore.sh \
	/var/lib/ca-certificates/java-cacerts \
	/opt/payara6/certs/rootcert.pem \
	local-payara

USER abuild

ENV HOME /home/abuild
ENV PATH $GLASSFISH_HOME/bin:$JAVA_HOME/bin:/usr/local/bin:/usr/bin:/bin

WORKDIR $HOME

RUN tmpfile=`mktemp` && \
    curl --silent --show-error --location --output $tmpfile \
	https://repo1.maven.org/maven2/fish/payara/distributions/payara/6.2025.7/payara-6.2025.7.zip && \
    unzip -q -d /opt $tmpfile && \
    rm -rf $tmpfile && \
    asadmin delete-domain domain1

CMD ["start-glassfish.sh"]
