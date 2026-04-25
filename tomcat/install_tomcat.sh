#!/bin/bash
set -eu


TOMCAT_VERSION=11.0.7
TOMCAT_VERSION_MAJOR=11
TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_VERSION_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.zip"


if [[ ! -d .tomcat ]]; then mkdir -vp .tomcat; fi

if [[ ! -f ./.tomcat/apache-tomcat-"$TOMCAT_VERSION".zip ]]; then
	echo -e "\e[32m[INFO]\e[0m Downloading Tomcat $TOMCAT_VERSION..."
	wget "$TOMCAT_URL" --directory-prefix "./.tomcat/"
fi

echo -e "\e[32m[INFO]\e[0m Unpacking Tomcat $TOMCAT_VERSION..."
unzip ./.tomcat/apache-tomcat-"$TOMCAT_VERSION".zip -d "./.tomcat/$TOMCAT_VERSION"/

echo -e "\e[32m[INFO]\e[0m Setting x permissions to bin/catalina.sh..."
chmod +x ./.tomcat/"$TOMCAT_VERSION"/apache-tomcat-"$TOMCAT_VERSION"/bin/catalina.sh
