#!/usr/bin/bash

REPOS=0
cd $HOME/GIT/

for i in `ls $HOME/GIT/`; do
  for x in `ls $HOME/GIT/$i`; do
    cd $HOME/GIT/$i/$x
    if [ $(git status --porcelain 2>/dev/null | wc -l) -eq "0" ]; then
      true
    else
      REPOS=$((REPOS+1))
    fi
  done ;
done

echo "$REPOS"

