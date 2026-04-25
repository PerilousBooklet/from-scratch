#!/bin/bash

# ?
# gcc \
#   -Wall \
#   --debug \
#   -Og \
#   src/*.c \
#   -o .bin/main

# ?
gcc \
  -Wall \
  --debug \
  -Og \
  -Isrc $(find lib -type d -exec echo -I{} \;) \
  $(find src -name '*.c') \
  $(find lib -name '*.c') \
  -o ./.bin/main

# ?
./.bin/main
