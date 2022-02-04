FROM rkrahl/opensuse:15.3

RUN zypper --non-interactive install \
	java-devel-openjdk \
	mariadb-client \
	maven \
	mysql-connector-java \
	python-base \
	python-xml \
	unzip

RUN groupadd abuild && \
    useradd -g abuild -c "Build user" -d /home/abuild abuild && \
    mkdir -p /home/abuild/bin

COPY start-glassfish.sh /home/abuild/bin

RUN chmod 0755 /home/abuild/bin/start-glassfish.sh && \
    chown -R abuild:abuild /home/abuild

ENV JAVA_HOME /usr/lib64/jvm/java-11-openjdk
ENV LC_ALL en_US.UTF-8

USER abuild

ENV HOME /home/abuild
ENV GLASSFISH_HOME $HOME/payara5
ENV PATH $HOME/bin:$GLASSFISH_HOME/bin:$JAVA_HOME/bin:/usr/local/bin:/usr/bin:/bin

WORKDIR $HOME

RUN tmpfile=`mktemp` && \
    curl --silent --show-error --location --output $tmpfile \
	https://repo1.maven.org/maven2/fish/payara/distributions/payara/5.2021.9/payara-5.2021.9.zip && \
    unzip -q $tmpfile && \
    rm -rf $tmpfile && \
    asadmin delete-domain domain1

CMD ["bash"]
