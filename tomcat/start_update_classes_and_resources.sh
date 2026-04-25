#!/bin/bash
set -eu


JAVA_VERSION=21
export JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk
export PATH=$JAVA_HOME/bin:$PATH

TOMCAT_VERSION=11.0.7
export CATALINA_HOME=./.tomcat/apache-tomcat-"$TOMCAT_VERSION"
export CATALINA_BASE=./.tomcat/apache-tomcat-"$TOMCAT_VERSION"

export JPDA_ADDRESS="localhost:8000"
export JPDA_TRANSPORT=dt_socket


# update resources
# update classes -> rebuild

# WIP: ?
"$CATALINA_HOME"/bin/catalina.sh start
