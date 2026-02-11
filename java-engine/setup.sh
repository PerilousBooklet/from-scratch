#!/bin/bash

# NOTE: list the desired modules and install them locally
# NOTE: then setup some kind of update logic


MODULES=()

UMLDOCLET_VERSION=2.2.3
UMLDOCLET_URL="https://github.com/talsma-ict/umldoclet/releases/download/$UMLDOCLET_VERSION/umldoclet-$UMLDOCLET_VERSION.jar"

LIST=$(cat modules.txt)
for i in $LIST; do
  echo "$i"
done


echo -e "\e[32m[INFO]\e[0m Creating directories..."
mkdir -vp core/src/main
mkdir -vp core/{lib,bin,docs}


echo -e "\e[32m[INFO]\e[0m Creating Main.java..."
cat << EOT > core/src/main/Main.java
package main;

public class Main {
  
  public static void main(String[] args) {
    System.out.println("Hello there!");
  }
  
}
EOT


echo -e "\e[32m[INFO]\e[0m Installing modules..."
# for i in "${MODULES[@]}"; do
#   git clone "$i"
# done
# TODO: check version with awk
mkdir -v audio gui network input art graphics physics math ai


echo -e "\e[32m[INFO]\e[0m Downloading UMLDoclet..."
if [[ ! -f .tools ]]; then mkdir -v .tools; fi
wget "$UMLDOCLET_URL" --directory-prefix .tools
