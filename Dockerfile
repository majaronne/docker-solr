FROM phusion/baseimage:0.9.16

# Docker-apt wraps apt and makes sure that indexes are up-to-date then we install packages
ADD docker-apt /usr/local/bin/

# Fixes shell in docker-enter
ENV TERM xterm

WORKDIR /root

# Install software
RUN docker-apt dist-upgrade -y
RUN docker-apt install -y libjtds-java tomcat7 tomcat7-admin unzip wget at bind9-host && docker-apt build-dep -y nodejs && docker-apt clean

# Get and install Solr:
ENV SOLR_VERSION 4.10.4
RUN wget http://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.zip && unzip solr-${SOLR_VERSION}.zip && rm solr-${SOLR_VERSION}.zip && mv solr-${SOLR_VERSION} /usr/share/solr && touch /usr/share/solr/solr.log

# Add backup/restore scripts
ADD backup /opt/
ADD restore /opt/
RUN chmod +x /opt/backup /opt/restore

# Disable SSH
RUN rm /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN rm -rfv /etc/service/sshd

# Configure Tomcat7
ADD tomcat/tomcat7.default /etc/default/tomcat7

RUN mkdir /etc/service/tomcat7/
ADD tomcat/tomcat7 /etc/service/tomcat7/run
RUN chmod +x /etc/service/tomcat7/run
ADD tomcat/catalina.sh /usr/local/bin/catalina.sh
ADD tomcat/solr.xml /etc/tomcat7/Catalina/localhost/solr.xml
RUN chmod +x /usr/local/bin/catalina.sh
ADD tomcat/tomcat-users.xml /var/lib/tomcat7/conf/tomcat-users.xml

# Configure Solr
RUN touch /usr/share/solr/solr.log
RUN mkdir -p /usr/share/solr/node/
RUN cp -a /usr/share/solr/example/lib/ext/* /usr/share/tomcat7/lib
RUN ln -s /usr/share/java/jtds.jar /usr/share/tomcat7/lib
RUN cp -a /usr/share/solr/example/resources/log4j.properties /usr/share/tomcat7/lib
RUN cp -a /usr/share/solr/example/* /usr/share/solr/node/ && rm -fr /usr/share/solr/node/solr/collection1
RUN sed "s/solr\.log=.*\$/solr.log=\/usr\/share\/solr/" -i /usr/share/tomcat7/lib/log4j.properties
RUN cp /usr/share/solr/dist/solr-${SOLR_VERSION}.war /usr/share/solr/node/solr/solr.war

# Fix permissions
RUN chown -R tomcat7:tomcat7 /etc/tomcat7/Catalina/localhost/solr.xml /usr/share/solr/

EXPOSE 8080

# Run dist-upgrade as the last action
RUN docker-apt dist-upgrade -y && docker-apt clean
