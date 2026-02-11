#!/bin/bash

# BRAINSTORM: run the modules (audio/, gui/, models/, network/, ...) first, then the main code (main/)
# BRAINSTORM: each module (the main module too) contains the following structure
#             - src/
#               - audio/
#               - gui/
#               - network/
#               - input/
#               - art/
#               - graphics/
#               - physics/
#               - math/
#               - lib/
#               - bin/
#               - docs/
#               - run.sh/
#               - setup.sh/
#               - README.md/

# BRAINSTORM: so, basically to assemble the entire program we run the build script for each module, one at a time,
#             and then each module becomes a library for the main module, which is basically the program itself

# NOTE: use javadoc to aut-generate the Docs API website, with UMLDoclet


JAVA_VERSION=21

AUTHOR='author'
VERSION='0.0.1'

JAR_FILE="app-$VERSION.jar"

RESOURCES=(
  'resources/'
)

MODULES=()
MODULE_URLS=$(awk '{ print $1 }' modules.txt)
MODULE_NAMES=$(awk '{ print $2 }' modules.txt)
MODULE_VERSIONS=$(awk '{ print $3 }' modules.txt)


# Init
if [[ ! -d ./bin ]]; then
  mkdir -v ./bin
fi
if [[ ! -d ./lib ]]; then
  mkdir -v ./lib
fi


# Compile the modules and move them into the core module as libraries
for i in "${MODULES[@]}"; do
  (
    cd "$i" || exit
    ./run.sh
    cp ./*.jar ../core/lib/
  )
done


# Build source code
DEPS=$(echo $(find lib -name "*.jar" | sed -e 's|^./||g'))
if [[ $(find lib -type d -empty) == "lib" ]]; then
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
Main-Class: main.Main
EOT

# Include resource files
for i in "${RESOURCES[@]}"; do
	if [[ -d "$i" ]]; then
    mkdir -vp bin/"$i"
  fi
  cp -vr "$i"/* bin/"$i"
done


# Update Manifest.txt with list of third-party dependencies and resource folders
if [[ $(find ./lib -type d -empty) == "./lib" ]]; then
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
cp -v lib/*.jar bin/


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


# Run app
/usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/java -jar $JAR_FILE


# Clean build files
rm -vrf bin/*
