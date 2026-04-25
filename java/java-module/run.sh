#!/bin/bash
set -e


JAVA_VERSION=21

RESOURCES=(
  'resources'
)

AUTHOR='author'
VERSION='0.0.1'
NAME="module1"
JAR_FILE="$NAME-$VERSION.jar"


# Init
if [[ ! -d ./bin ]]; then
  mkdir -v ./bin
fi
if [[ ! -d ./lib ]]; then
  mkdir -v ./lib
fi
rm -f $JAR_FILE


# Build source code
DEPS=$(echo $(find lib -name "*.jar" | sed -e 's|^./||g'))
if [[ -z $(find lib -name "*.jar") ]]; then
  /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
    -d bin \
    $(find src -name "*.java")
else
  DEPS_FOR_JAVAC=$(echo $DEPS | sed 's| |:|g')
  # NOTE: Java 8 requires "-class-path"
  # NOTE: Java 9 and beyond use "--class-path" instead
  if [[ $JAVA_VERSION == 8 ]]; then
    /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
      -class-path "$DEPS_FOR_JAVAC" \
      -d bin \
      $(find src -name "*.java")
  else
    if [[ $JAVA_VERSION -gt 8 ]]; then
      /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
        --class-path "$DEPS_FOR_JAVAC" \
        -d bin \
        $(find src -name "*.java")
    fi
  fi
fi


# Create Manifest file
cat << EOT > Manifest.txt
Manifest-Version: $VERSION
Created-By: $AUTHOR
EOT


# Include resource files
for i in "${RESOURCES[@]}"; do
	if [[ -d "$i" ]]; then
    mkdir -vp bin/"$i"
  fi
  if [[ -n $(ls -A "$i" 2>/dev/null) ]]; then
    cp -vr "$i"/* bin/"$i"
  fi
done


# Update Manifest.txt with list of third-party dependencies and resource folders
if [[ -z $(find lib -name "*.jar") ]]; then
  echo -e "\e[32m[INFO]\e[0m ./lib is empty"
  echo -e "" >> Manifest.txt
else
  echo -e "Class-Path: " >> Manifest.txt
  for i in $DEPS; do
    printf "  %s\n" "$i" >> Manifest.txt
  done
  for i in "${RESOURCES[@]}"; do
    printf "  %s\n" "$i" >> Manifest.txt
  done
  echo "" >> Manifest.txt
fi


# Include third-party libraries
if ls lib/*.jar &>/dev/null; then
  cp -v lib/*.jar bin/
fi


# Create jar file
if [[ -f $JAR_FILE ]]; then
  jar \
    --verbose \
    --update \
    --file $JAR_FILE \
    --manifest Manifest.txt \
    -C bin \
    .
else
  jar \
    --verbose \
    --create \
    --file $JAR_FILE \
    --manifest Manifest.txt \
    -C bin \
    .
fi


# Clean build files
rm -vrf bin/*
