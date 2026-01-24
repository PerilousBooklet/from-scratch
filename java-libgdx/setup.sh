#!/usr/bin/bash


JAVA_VERSION=11
GDX_LIFTOFF_VERSION=1.12.1.12
MUNDUS_VERSION=0.5.1


wget \
  "https://github.com/libgdx/gdx-liftoff/releases/download/v$GDX_LIFTOFF_VERSION/gdx-liftoff-$GDX_LIFTOFF_VERSION.jar" \
  --directory-prefix "./.tools"

if [[ ! -d ./.tools/mundus ]]; then
  mkdir -vp ./.tools/mundus
fi
wget \
  "https://github.com/JamesTKhan/Mundus/releases/download/v$MUNDUS_VERSION/$MUNDUS_VERSION.zip" \
  --directory-prefix "./.tools/mundus"
unzip \
  "$MUNDUS_VERSION.zip" \
  -d "./.tools/mundus/"

/usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/java \
  -jar "./.tools/gdx-liftoff-$GDX_LIFTOFF_VERSION.jar"
