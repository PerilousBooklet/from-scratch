# An engine written in Java from scratch

<!-- 
    BRAINSTORM: run the modules (audio/, gui/, models/, network/, ...) first, then the main code (main/)
    BRAINSTORM: each module (the main module too) contains the following structure
                - src/
                  - audio/
                  - gui/
                  - network/
                  - input/
                  - art/
                  - graphics/
                  - physics/
                  - math/
                  - lib/
                  - bin/
                  - docs/
                  - run.sh/
                  - setup.sh/
                  - README.md/

    BRAINSTORM: so, basically to assemble the entire program we run the build script for each module, one at a time,
                and then each module becomes a library for the main module, which is basically the program itself

    NOTE: use javadoc to auto-generate the Docs API website, with UMLDoclet
-->

...

## Usage

Copy the `java-engine` folder, copy the `java-module` folder into it and run the engine's `setup.sh` and `run.sh` scripts.

- Each `java-module` is a piece of the engine
- A module relates to one domain only (es. `audio`, `graphics`, `network`, ...)
