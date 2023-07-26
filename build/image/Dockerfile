FROM rkrahl/opensuse:15.5

RUN zypper --non-interactive refresh

RUN zypper --non-interactive install \
	acl \
	glibc-locale \
	java-11-openjdk-devel \
	less \
	mariadb-client \
	maven \
	mysql-connector-java \
	unzip

RUN groupadd abuild && \
    useradd -g abuild -c "Build user" -d /home/abuild abuild && \
    mkdir -p /home/abuild/.m2 /home/abuild/bin /home/abuild/test

COPY start-glassfish.sh /home/abuild/bin
COPY add-test-accounts.sh /home/abuild/bin
COPY m2-settings.xml /home/abuild/.m2/settings.xml

RUN chmod 0755 \
	/home/abuild/bin/add-test-accounts.sh \
	/home/abuild/bin/start-glassfish.sh && \
    mkdir -p \
	/home/abuild/test/data/ids/archive \
	/home/abuild/test/data/ids/cache \
	/home/abuild/test/data/ids/main && \
    chown -R abuild:abuild /home/abuild

ENV JAVA_HOME /usr/lib64/jvm/java-11-openjdk
ENV LC_ALL en_US.UTF-8

USER abuild

ENV HOME /home/abuild
ENV GLASSFISH_HOME $HOME/payara6
ENV PATH $HOME/bin:$GLASSFISH_HOME/bin:$JAVA_HOME/bin:/usr/local/bin:/usr/bin:/bin

WORKDIR $HOME

RUN tmpfile=`mktemp` && \
    curl --silent --show-error --location --output $tmpfile \
	https://repo1.maven.org/maven2/fish/payara/distributions/payara/6.2023.7/payara-6.2023.7.zip && \
    unzip -q $tmpfile && \
    rm -rf $tmpfile && \
    asadmin delete-domain domain1

CMD ["start-glassfish.sh"]
