# Base docker image for solr-5x

```bash
  docker build -t nota/solr .
```

To use this base your own image on this and add you collections to: 
/opt/solr/server/solr/

Example Dockerfile for image:
```
FROM nota/solr:latest

COPY solr/collections /opt/solr/server/solr
```

If you need IP-limiting, stick to the solr4 version for now.

# Starting and stopping
The solr server comes with its own server now. Unfortunately, the start
and stop commands don't play nice the runit (sv command).

Instead, the server is started by the init system (from a script in 
/etc/my_init.d). If you need to start and stop it, use /opt/start-solr.sh
and /opt/stop-solr.sh.

# Create a backup
docker exec <CONTRAINER> /opt/backup > dump.tar.bz2

# Restore backup
docker exec -i <CONTAINER> /opt/restore < dump.tar.bz2
