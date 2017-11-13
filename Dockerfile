FROM phusion/baseimage:0.9.19

# Docker-apt wraps apt and makes sure that indexes are up-to-date then we install packages
COPY docker-apt /usr/local/bin/

# Fixes shell in docker-enter
ENV TERM xterm

WORKDIR /opt

# Install software
RUN docker-apt dist-upgrade -y 
RUN docker-apt install -y apt-utils unzip wget at openjdk-8-jre-headless lsof && \
  docker-apt clean

# Get and install Solr:
ENV SOLR_VERSION 6.6.2
RUN wget http://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz
RUN tar xzf solr-${SOLR_VERSION}.tgz
RUN ln -s /opt/solr-${SOLR_VERSION} /opt/solr
RUN rm /opt/solr-${SOLR_VERSION}.tgz

# Add backup/restore/run scripts
COPY backup /opt/backup
COPY restore /opt/restore
COPY start-solr.sh /opt/start-solr.sh
COPY stop-solr.sh /opt/stop-solr.sh
RUN chmod +x /opt/backup /opt/restore /opt/start-solr.sh /opt/stop-solr.sh

# Add and configure Solr service
RUN mkdir -p /etc/my_init.d
COPY solr-run /etc/my_init.d/98-solr.sh
RUN chmod +x /etc/my_init.d/98-solr.sh

# Disable SSH
RUN rm /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN rm -rfv /etc/service/sshd

# Configure Solr
#RUN touch /usr/share/solr/solr.log
RUN mkdir -p /usr/share/solr/node/
RUN cp -a /opt/solr/example/* /usr/share/solr/node/ && rm -fr /usr/share/solr/node/solr/collection1

EXPOSE 8080 

# Run dist-upgrade as the last action
RUN docker-apt dist-upgrade -y && docker-apt clean
