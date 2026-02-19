#!/bin/bash


NAME="module1"

UMLDOCLET_VERSION=2.2.3
UMLDOCLET_URL="https://github.com/talsma-ict/umldoclet/releases/download/$UMLDOCLET_VERSION/umldoclet-$UMLDOCLET_VERSION.jar"


echo -e "\e[32m[INFO]\e[0m Creating directories..."
mkdir -vp src/$NAME/main
mkdir -vp lib


echo -e "\e[32m[INFO]\e[0m Creating main class file..."
touch ./src/$NAME/main/Main.java
cat << EOT > ./src/$NAME/main/Main.java
package $NAME.main;

public class ${NAME^} {
  
}
EOT


echo -e "\e[32m[INFO]\e[0m Downloading UMLDoclet..."
if [[ ! -f .tools ]]; then
  mkdir -v .tools
fi
wget "$UMLDOCLET_URL" --directory-prefix .tools
