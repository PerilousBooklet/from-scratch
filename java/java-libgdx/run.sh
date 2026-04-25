#!/usr/bin/bash
set -e

cd "src" || exit

./gradlew lwjgl3:run
