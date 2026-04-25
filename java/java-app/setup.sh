#!/bin/bash
set -e


UMLDOCLET_VERSION=2.2.3
UMLDOCLET_URL="https://github.com/talsma-ict/umldoclet/releases/download/$UMLDOCLET_VERSION/umldoclet-$UMLDOCLET_VERSION.jar"


echo -e "\e[32m[INFO]\e[0m Creating directories..."
mkdir -vp src/{main,test}


echo -e "\e[32m[INFO]\e[0m Creating Main.java..."
cat << EOT > src/main/Main.java
package main;

public class Main {
  
  public static void main(String[] args) {
    System.out.println("Hello there!");
  }
  
}
EOT


echo -e "\e[32m[INFO]\e[0m Downloading UMLDoclet..."
if [[ ! -f .tools ]]; then mkdir -v .tools; fi
wget "$UMLDOCLET_URL" --directory-prefix .tools
