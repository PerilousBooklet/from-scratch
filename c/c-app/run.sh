#!/bin/bash

# ?
# gcc \
#   -O2 \
#   src/*.c \
#   -o .bin/main

# ?
gcc \
  -O2 \
  -Isrc $(find lib -type d -exec echo -I{} \;) \
  $(find src -name '*.c') \
  $(find lib -name '*.c') \
  -o ./.bin/main

# ?
./.bin/main
