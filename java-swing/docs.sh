#!/bin/bash


JAVA_VERSION=21


/usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javadoc \
  -d docs \
  -sourcepath src \
  -subpackages $(
    find src \
      -maxdepth 1 \
      -type d ! -name ".*" -printf "%f " \
      | sed 's|src ||g' \
      | sed 's|resources ||g' \
      | sed 's|web ||g'
  ) \
  --add-stylesheet .styles/dark.css \
  -docletpath .tools/"$(ls .tools)" \
  -doclet nl.talsmasoftware.umldoclet.UMLDoclet
