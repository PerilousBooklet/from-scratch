#!/bin/bash


JAVA_VERSION=21

RESOURCES=(
  'resources'
)

AUTHOR='author'
VERSION='0.0.1'
JAR_FILE="app-$VERSION.jar"

MODULES=()
MODULES_URLS=$(awk '{ print $1 }' modules.txt)
# MODULES_NAMES=$(awk '{ print $2 }' modules.txt)
MODULES_NAMES=(module1)
MODULES_VERSIONS=$(awk '{ print $3 }' modules.txt)


# Init
if [[ ! -d ./core/bin ]]; then
  mkdir -v ./core/bin
fi
if [[ ! -d ./core/lib ]]; then
  mkdir -v ./core/lib
fi
rm -f $JAR_FILE


# Compile the modules and move them into the core module as libraries
for i in $MODULES_NAMES; do
  (
    cd "$i" || exit
    ./run.sh
    cp -v ./*.jar ../core/lib/
  )
done


# Build source code
DEPS=$(echo $(find core/lib -name "*.jar" | sed -e 's|^./||g'))
if [[ -z $(find core/lib -name "*.jar") ]]; then
  /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
    -d core/bin \
    $(find core/src -name "*.java")
else
  DEPS_FOR_JAVAC=$(echo $DEPS | sed 's| |:|g')
  # NOTE: Java 8 requires "-class-path"
  # NOTE: Java 9 and beyond use "--class-path" instead
  if [[ $JAVA_VERSION == 8 ]]; then
    /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
      -class-path "$DEPS_FOR_JAVAC" \
      -d core/bin \
      $(find core/src -name "*.java")
  else
    if [[ $JAVA_VERSION -gt 8 ]]; then
      /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
        --class-path "$DEPS_FOR_JAVAC" \
        -d core/bin \
        $(find core/src -name "*.java")
    fi
  fi
fi


# Create Manifest file
cat << EOT > core/Manifest.txt
Manifest-Version: $VERSION
Created-By: $AUTHOR
Main-Class: main.Main
EOT

# Include resource files
for i in "${RESOURCES[@]}"; do
	if [[ -d "$i" ]]; then
    mkdir -vp core/bin/"$i"
  fi
  if [[ -n $(ls -A core/"$i" 2>/dev/null) ]]; then
    cp -vr core/"$i"/* core/bin/"$i"
  fi
done


# Update Manifest.txt with list of third-party dependencies and resource folders
if [[ -z $(find core/lib -name "*.jar") ]]; then
  echo -e "\e[32m[INFO]\e[0m ./core/lib is empty"
  echo -e "" >> core/Manifest.txt
else
  echo -e "Class-Path: " >> core/Manifest.txt
  for i in $DEPS; do
    printf "  %s\n" "$i" >> core/Manifest.txt
  done
  for i in "${RESOURCES[@]}"; do
    printf "  %s\n" "$i/" >> core/Manifest.txt
  done
  echo "" >> core/Manifest.txt
fi


# Insert third-party libraries into the jar file
if ls core/lib/*.jar &>/dev/null; then
  for jar in core/lib/*.jar; do
    unzip -o "$jar" -d core/bin/
  done
fi


# Create jar file
if [[ -f core/$JAR_FILE ]]; then
  jar \
    --verbose \
    --update \
    --file core/$JAR_FILE \
    --manifest core/Manifest.txt \
    -C core/bin \
    .
else
  jar \
    --verbose \
    --create \
    --file core/$JAR_FILE \
    --manifest core/Manifest.txt \
    -C core/bin \
    .
fi


# Run app
/usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/java -jar core/$JAR_FILE


# Clean build files
rm -vrf core/bin/*
