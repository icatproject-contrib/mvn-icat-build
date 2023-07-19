FROM rkrahl/opensuse:15.3

RUN zypper --non-interactive install \
	acl \
	java-1_8_0-openjdk-devel \
	less \
	mariadb-client \
	maven \
	python-base \
	python-xml \
	unzip

# The distributed mysql-connector-java in opensuse:15.3 does not work
# with java-1_8_0-openjdk any more.  (A bug?)  Use the RPM from
# opensuse:42.3 instead.
COPY mysql-connector-java-5.1.42-10.3.1.noarch.rpm /tmp
RUN zypper --non-interactive install \
	/tmp/mysql-connector-java-5.1.42-10.3.1.noarch.rpm && \
    zypper --non-interactive addlock mysql-connector-java && \
    rm /tmp/mysql-connector-java-5.1.42-10.3.1.noarch.rpm

RUN groupadd abuild && \
    useradd -g abuild -c "Build user" -d /home/abuild abuild && \
    mkdir -p /home/abuild/.m2 /home/abuild/bin /home/abuild/test

COPY start-glassfish.sh /home/abuild/bin
COPY add-test-accounts.sh /home/abuild/bin
COPY m2-settings.xml /home/abuild/.m2/settings.xml

RUN chmod 0755 \
	/home/abuild/bin/add-test-accounts.sh \
	/home/abuild/bin/start-glassfish.sh && \
    chown -R abuild:abuild /home/abuild

ENV JAVA_HOME /usr/lib64/jvm/java-1.8.0-openjdk
ENV LC_ALL en_US.UTF-8

USER abuild

ENV HOME /home/abuild
ENV GLASSFISH_HOME $HOME/payara41
ENV PATH $HOME/bin:$GLASSFISH_HOME/bin:$JAVA_HOME/bin:/usr/local/bin:/usr/bin:/bin

WORKDIR $HOME

RUN tmpfile=`mktemp` && \
    curl --silent --show-error --location --output $tmpfile \
	https://repo1.maven.org/maven2/fish/payara/distributions/payara/4.1.2.181/payara-4.1.2.181.zip && \
    unzip -q $tmpfile && \
    rm -rf $tmpfile && \
    asadmin delete-domain domain1

CMD ["start-glassfish.sh"]
