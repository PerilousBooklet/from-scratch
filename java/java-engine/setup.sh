#!/bin/bash
set -e


# MODULES_URLS=$(awk '{ print $1 }' modules.txt)
# MODULES_NAMES=$(awk '{ print $2 }' modules.txt)
# MODULES_VERSIONS=$(awk '{ print $3 }' modules.txt)

MODULES_NAMES=(
  module1
)

UMLDOCLET_VERSION=2.2.3
UMLDOCLET_URL="https://github.com/talsma-ict/umldoclet/releases/download/$UMLDOCLET_VERSION/umldoclet-$UMLDOCLET_VERSION.jar"


echo -e "\e[32m[INFO]\e[0m Creating directories..."
mkdir -vp core/{src/main,lib,bin}


echo -e "\e[32m[INFO]\e[0m Creating Main.java..."
cat << EOT > core/src/main/Main.java
package main;

public class Main {
  
  public static void main(String[] args) {
    module1.main.Main module1 = new module1.main.Main();
    module1.print_module1("This is module 1!");
  }
  
}
EOT


# echo -e "\e[32m[INFO]\e[0m Installing modules..."
# for i in "${MODULE_URLS[@]}"; do
#   git clone "$i"
# done
# TODO: check version with awk

# mkdir -v audio gui network input art graphics physics math ai


echo -e "\e[32m[INFO]\e[0m Downloading UMLDoclet..."
if [[ ! -f .tools ]]; then mkdir -v .tools; fi
wget "$UMLDOCLET_URL" --directory-prefix .tools
