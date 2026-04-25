#!/bin/bash


echo -e "\e[32m[INFO]\e[0m Creating folders..."
mkdir -vp src lib .bin


echo -e "\e[32m[INFO]\e[0m Writing main file..."
touch src/main.c
cat << EOT > src/main.c
#include "main.h"

void printSomething(char string[]) {
    printf("%s\n", string);
}

int main(void) {
    printSomething("Hello there!");
    return 0;
}
EOT


echo -e "\e[32m[INFO]\e[0m Creating main header file..."
touch src/main.h
cat << EOT > src/main.h
#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>

void printSomething(char string[]);

#endif
EOT

echo -e "\e[32m[INFO]\e[0m Creating Lite XL project module..."
cat << EOT > .lite_project.lua
local config = require "core.config"

table.insert(config.ignore_files, ".obj")
table.insert(config.ignore_files, ".bin")
EOT

