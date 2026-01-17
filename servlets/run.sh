#!/bin/bash


JAVA_VERSION=17
AUTHOR='author'
VERSION='0.0.1'
WAR_FILE="webapp-$VERSION.war"
RESOURCES=(
  'resources/'
)

# Init
if [[ ! -d ./bin ]]; then
  mkdir -v ./bin
fi
if [[ ! -d ./lib ]]; then
  mkdir -v ./lib
fi

mkdir -vp bin/{META-INF,WEB-INF}
mkdir -vp bin/META-INF
mkdir -vp bin/WEB-INF/{classes,lib}
mkdir -vp bin/WEB-INF/classes/{static,templates}


# Build source code
DEPS=$(echo $(find lib -name "*.jar" | sed -e 's|^./||g'))
if [[ $(find lib -type d -empty) == "lib" ]]; then
  /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
    -d bin/WEB-INF/classes \
    $(find src -name "*.java")
else
  DEPS_FOR_JAVAC=$(echo $DEPS | sed 's| |:|g')
  # NOTE: Java 8 requires "-class-path"
  # NOTE: Java 9 and beyond use "--class-path" instead
  if [[ $JAVA_VERSION == 8 ]]; then
    /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
      -class-path "$DEPS_FOR_JAVAC" \
      -d bin/classes \
      $(find src -name "*.java")
  else
    if [[ $JAVA_VERSION -gt 8 ]]; then
      /usr/lib/jvm/java-$JAVA_VERSION-openjdk/bin/javac \
        --class-path "$DEPS_FOR_JAVAC" \
        -d bin/classes \
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
cp -v lib/*.jar bin/WEB-INF/lib/

# Create jar file
if [[ -f $WAR_FILE ]]; then
  jar \
    --verbose \
    --update \
    --file $WAR_FILE \
    --manifest Manifest.txt \
    -C bin \
    .
else
  jar \
    --verbose \
    --create \
    --file $WAR_FILE \
    --manifest Manifest.txt \
    -C bin \
    .
fi

# Generate API Docs website
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

# Run app
# FIX: HTTP Status 404 – Not Found
cp -v "$WAR_FILE" .tomcat/webapps/ROOT/
CATALINA_HOME=".tomcat" .tomcat/bin/startup.sh "$@"
xdg-open "http://localhost:8080/hello"
# TODO: how do I easily stop tomcat?

# Clean build files
# rm -vrf bin/*
# rm -v .tomcat/webapps/ROOT/$WAR_FILE
