#!/bin/bash
if [[ ! -f packages-to-build.txt ]]; then touch packages-to-build.txt; fi
echo "" > packages-to-build.txt
for i in ./packages/*; do
  if [ -d "$i/.git" ]; then
    echo -e "\e[32m[INFO]\e[0m Updating $i"
    (
      echo -e "\e[32m[INFO]\e[0m Checking $i..."
      cd "$i" || exit
      git fetch origin
      LOCAL_HASH=$(git rev-parse HEAD)
      REMOTE_HASH=$(git rev-parse origin/HEAD)
      if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
        echo -e "\e[32m[INFO]\e[0m $i is up to date."
      else
        echo -e "\e[33m[WARNING]\e[0m $i is out of date."
        echo "$i" >> packages-to-build.txt
        REMOTE_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
        if git show-ref --verify --quiet "refs/remotes/origin/$REMOTE_BRANCH"; then
          git fetch origin
          LOCAL_HASH=$(git rev-parse HEAD)
          REMOTE_HASH=$(git rev-parse origin/HEAD)
          if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
            echo -e "\e[33m[WARNING]\e[0m Showing diff..."
            git diff "$LOCAL_HASH" "$REMOTE_HASH"
            echo -e "\e[33m[WARNING]\e[0m Pulling latest changes..."
            git pull origin "$REMOTE_BRANCH"
          fi
        else
          echo -e "\e[31m[ERROR]\e[0m Remote branch '$REMOTE_BRANCH' not found for $i."
        fi
      fi
    )
  else
    echo -e "\e[32m[INFO]\e[0m Skipping $i (not a git repo)"
  fi
done
