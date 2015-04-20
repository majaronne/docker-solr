#!/bin/bash

export JAVA_HOME="/usr/lib/jvm/default-java";
source "/etc/default/tomcat7";
export CATALINA_HOME="/usr/share/tomcat7";
export CATALINA_BASE="/var/lib/tomcat7";
export JAVA_OPTS="-Djava.awt.headless=true -Xmx6122m -XX:+UseConcMarkSweepGC";
export CATALINA_PID="/var/run/tomcat7.pid";
export CATALINA_TMPDIR="/tmp/tomcat7-tomcat7-tmp";
export LANG="";
export JSSE_HOME="/usr/lib/jvm/default-java/jre/";
mkdir -p $CATALINA_TMPDIR && chown tomcat7:tomcat7 $_
cd /var/lib/tomcat7 && exec /usr/share/tomcat7/bin/catalina.sh $*
