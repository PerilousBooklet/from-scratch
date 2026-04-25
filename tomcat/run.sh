#!/bin/bash
set -eu

# Enable extended globbing
shopt -s extglob


JAVA_VERSION=21
export JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk
export PATH=$JAVA_HOME/bin:$PATH

TOMCAT_VERSION=11.0.7
# TOMCAT_PORT=
# TOMCAT_PORT_DEBUG=
CATALINA_HOME=./.tomcat/"$TOMCAT_VERSION"/apache-tomcat-"$TOMCAT_VERSION"
CATALINA_BASE=./.tomcat/"$TOMCAT_VERSION"/apache-tomcat-"$TOMCAT_VERSION"/base

# NOTES

# https://tomcat.apache.org/tomcat-10.1-doc/RUNNING.txt
# https://www.jetbrains.com/guide/java/tutorials/working-with-apache-tomcat/working-with-tomcat/
# https://intellij-support.jetbrains.com/hc/en-us/community/posts/360000355704-Catalina-base-is-overwritten-in-IntelliJ

# https://www.google.com/search?q=https://www.jetbrains.com/help/idea/troubleshooting-common-tomcat-issues.html
# https://www.google.com/search?q=https://wiki.apache.org/tomcat/Introduction%23What_is_CATALINA_HOME_and_CATALINA_BASE.3F
# https://www.google.com/search?q=https://www.baeldung.com/tomcat-catalina-home-vs-catalina-base
# https://www.google.com/search?q=https://stackoverflow.com/questions/11252156/how-to-create-a-new-tomcat-instance-without-copying-the-whole-folder

# https://stackoverflow.com/questions/35600344/intellij-tomcat-local-run-configuration-what-happens-behind-the-scenes
# https://mkyong.com/intellij/intellij-idea-run-debug-web-application-on-tomcat/

if [[ ! -d $CATALINA_BASE ]]; then mkdir -v $CATALINA_BASE; fi
# mv -v "$CATALINA_HOME/!(bin|lib)" "$CATALINA_BASE"/
# cp -vr "$CATALINA_HOME"/{bin,lib} "$CATALINA_BASE"/


if [[ ! -d "$CATALINA_BASE"/conf/Catalina/localhost/ ]]; then mkdir -v "$CATALINA_BASE"/conf/Catalina/localhost/; fi
touch "$CATALINA_BASE"/conf/Catalina/localhost/ROOT.xml
# TODO: write the ROOT.xml
cat << EOT > "$CATALINA_BASE"/conf/Catalina/localhost/ROOT.xml
<Context 
   docBase="${catalina.home}/webapps/manager" 
    reloadable="true" 
    privileged="true">
    
    <Resources cachingAllowed="true" cacheMaxSize="100000" />
</Context>
EOT

touch "$CATALINA_BASE"/conf/logging.properties
cat << EOT > "$CATALINA_BASE"/conf/logging.properties

EOT


# TODO: quando funziona, copiare e rimuovere ogni riferimento a RWMS (occhio!) e mettere sulla chiavetta per fare la repo
# 	  tomcat-from-scratch, utilizzabile ance per altri progetti complessi che usano tomcat

# TODO: use tmux to keep the tomcat session in the background

exec "$CATALINA_HOME"/bin/catalina.sh run \
	-Dcatalina.home="$CATALINA_HOME" \
	-Dcatalina.base="$CATALINA_BASE"

# firefox "http://localhost:8080/dashboard"
