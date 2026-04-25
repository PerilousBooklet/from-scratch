#!/usr/bin/bash
set -e


JAVA_VERSION=21

GDX_LIFTOFF_VERSION=1.12.1.12

MUNDUS_VERSION=0.5.1


echo -e "\e[32m[INFO]\e[0m Download LibGDX Liftoff..."
wget \
  "https://github.com/libgdx/gdx-liftoff/releases/download/v$GDX_LIFTOFF_VERSION/gdx-liftoff-$GDX_LIFTOFF_VERSION.jar" \
  --directory-prefix "./.tools"


echo -e "\e[32m[INFO]\e[0m Download Mundus..."
if [[ ! -d ./.tools/mundus ]]; then mkdir -vp ./.tools/mundus; fi
wget \
  "https://github.com/JamesTKhan/Mundus/releases/download/v$MUNDUS_VERSION/$MUNDUS_VERSION.zip" \
  --directory-prefix "./.tools/mundus"
unzip "./.tools/mundus/$MUNDUS_VERSION.zip" -d "./.tools/mundus/"


echo -e "\e[32m[INFO]\e[0m Run LibGDX Liftoff..."
/usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/java -jar "./.tools/gdx-liftoff-$GDX_LIFTOFF_VERSION.jar"


# TODO: install Mundus
