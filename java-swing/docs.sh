#!/bin/bash


JAVA_VERSION=21


echo -e "\e[32m[INFO]\e[0m Install Javadoc dark theme..."
if [[ ! -d ./.styles ]]; then mkdir -v ./.styles; fi
# if [[ ! -f ./.styles/javadoc-dark.css ]]; then
#   touch ./.styles/javadoc-dark.css
#   cat << EOT > ./.styles/javadoc-dark.css
# :root {
#     --body-text-color: #e0e0e3;
#     --block-text-color: #e6e7ef;
#     --body-background-color: #404040;
#     --section-background-color: #484848;
#     --detail-background-color: #404040;
#     --navbar-background-color: #505076;
#     --navbar-text-color: #ffffff;
#     --subnav-background-color: #303030;
#     --selected-background-color: #f8981d;
#     --selected-text-color: #253441;
#     --selected-link-color: #1f389c;
#     --even-row-color: #484848;
#     --odd-row-color: #383838;
#     --title-color: #ffffff;
#     --link-color: #a0c0f8;
#     --link-color-active: #ffb863;
#     --snippet-background-color: #383838;
#     --snippet-text-color: var(--block-text-color);
#     --snippet-highlight-color: #f7c590;
#     --border-color: #383838;
#     --table-border-color: #000000;
#     --search-input-background-color: #000000;
#     --search-input-text-color: #ffffff;
#     --search-input-placeholder-color: #909090;
#     --search-tag-highlight-color: #ffff00;
#     --copy-icon-brightness: 250%;
#     --copy-button-background-color-active: rgba(168, 168, 176, 0.3);
#     --invalid-tag-background-color: #ffe6e6;
#     --invalid-tag-text-color: #000000;
# }
# EOT
# fi
if [[ ! -f ./.styles/javadoc-dark.css ]]; then
  touch ./.styles/javadoc-dark.css
  cat << EOT > ./.styles/javadoc-dark.css
:root {
    --body-text-color: #abb2bf;
    --block-text-color: #c8ccd4;
    --body-background-color: #282c34;
    --section-background-color: #2c313a;
    --detail-background-color: #21252b;

    --navbar-background-color: #3a3f4b;
    --navbar-text-color: #ffffff;

    --subnav-background-color: #21252b;

    --selected-background-color: #61afef;
    --selected-text-color: #282c34;
    --selected-link-color: #98c379;

    --even-row-color: #2c313a;
    --odd-row-color: #21252b;

    --title-color: #ffffff;

    --link-color: #61afef;
    --link-color-active: #e5c07b;

    --snippet-background-color: #21252b;
    --snippet-text-color: #abb2bf;
    --snippet-highlight-color: #e5c07b;

    --border-color: #3a3f4b;
    --table-border-color: #000000;

    --search-input-background-color: #1e2228;
    --search-input-text-color: #ffffff;
    --search-input-placeholder-color: #5c6370;

    --search-tag-highlight-color: #e5c07b;

    --copy-icon-brightness: 250%;
    --copy-button-background-color-active: rgba(97, 175, 239, 0.25);

    --invalid-tag-background-color: #e06c75;
    --invalid-tag-text-color: #ffffff;
}
EOT
fi


# FIX: breaks when using ext-libs
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
  --add-stylesheet .styles/javadoc-dark.css \
  -docletpath .tools/"$(find ./.tools -name '*umldoclet*.jar' | sed 's|./.tools/||g')" \
  -doclet nl.talsmasoftware.umldoclet.UMLDoclet


firefox ./docs/index.html
