# Base docker image for solr-4x + tomcat7

```bash
  docker build -t nota/solr .
```

To use this base your own image on this and add you collections:
/usr/share/solr/nota/

Example Dockerfile for image:
```
FROM nota/solr:4.10.4

ADD solr/collections /usr/share/solr/nota/

# Reenable IP-limit for solr
RUN sed "s/<\!-- <Valve \(.*\) -->$/<Valve \1/" -i /etc/tomcat7/Catalina/localhost/solr.xml
```

# Create a backup
docker exec <CONTRAINER> /opt/backup > dump.tar.bz2

# Restore backup
docker exec <CONTAINER> /opt/restore < dump.tar.bz2
