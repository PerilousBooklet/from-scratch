#!/bin/bash
set -eu


JAVA_VERSION=21
export JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk
export PATH=$JAVA_HOME/bin:$PATH

TOMCAT_VERSION=11.0.7
CATALINA_HOME=./.tomcat/apache-tomcat-"$TOMCAT_VERSION"


"$CATALINA_HOME"/bin/catalina.sh stop
